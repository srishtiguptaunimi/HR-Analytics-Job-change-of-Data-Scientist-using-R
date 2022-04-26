#Load packages
library(dplyr)
library(tidyr)
library(plyr)
library(ggplot2)
library(lme4)
library(AICcmodavg)
library(magrittr)
library(scales)
library(gmodels)
library(agricolae)
library(multcomp)
library(Sleuth2)
library(MASS)
library(car)
library(glmnet)
library(caret)
library(leaps)
library(bestglm)
library(VIM)
library("VIM")
library(forcats)
library(stringr)
library(formattable)
library(MASS)
library(AppliedPredictiveModeling)
library(klaR)
library(randomForest)
library(pROC)
library(OptimalCutpoints)
library(ISLR)
library(naniar)
library(factoextra)
library(lsmeans)
library(tidyverse)
library(Sleuth3)
library(tree)
library(ranger)
library(partykit)
library(parallel)
library(doParallel)
library(xgboost)
library(kernlab)
library(MLmetrics)
library(smotefamily)
library(DMwR)
library(rminer)
library(foreach)

#Load dataset( we are loading train dataset because in Test dataset Target variable is not present)
#Train data
aug = read.csv("aug_train.csv", header=T, na.strings=c(""," ","NA"))
aug = data.frame(aug)
head(aug)
str(aug) #19158 obs & 14 variables

#Explore the City Variable 

aug$city = as.factor(aug$city)
aug %>% count('city') #categorical w/123 unique levels (or cities)

#Explore 'city_development_index' variable
range(aug$city_development_index) #values range from 0.448 to 0.949

#Explore 'Gender' feature
aug$gender = as.factor(aug$gender)
levels(aug$gender)


#Explore 'relevent_experience' variable
aug$relevent_experience = as.factor(aug$relevent_experience)
levels(aug$relevent_experience) #relevant work experience or not; 0 = no experience / 1 = experience

#Inspect 'enrolled_university' variable
aug$enrolled_university = as.factor(aug$enrolled_university)
levels(aug$enrolled_university) #full time, part time, or no enrollment

#Inspect 'education_level' variable
aug$education_level = as.factor(aug$education_level)
table(aug$education_level) #Graduate, High School, Masters, PhD, or Primary School

#Inspect 'major_discipline' variable
aug$major_discipline = as.factor(aug$major_discipline)
aug %>% count('major_discipline') #STEM, Business, Humanities, Arts, Other, or No Major

#Inspect 'experience' variable
aug$experience = as.factor(aug$experience)
table(aug$experience) #grouped between less than 1 and greater than 20

#Inspect 'company_size' variable
aug$company_size = as.factor(aug$company_size)
aug %>% count('company_size') #grouped between less than 10 and 5000-9999 employees

#Inspect 'company_type' variable
aug$company_type = as.factor(aug$company_type)
table(aug$company_type) #Early-Stage Startup, Funded Startup, NGO, Public Sector, Private Ltd, or Other

#Inspect 'last_new_job' variable
aug$last_new_job = as.factor(aug$last_new_job)
table(aug$last_new_job) #grouped between 1 and greater than 4 years, as well as never

#Inspect 'training_hours' variable
range(aug$training_hours) #values range from 1 to 336 hours

#Inspect 'target' variable (target variable)
aug$target = as.factor(aug$target)
levels(aug$target) #0 = Not looking for a job change, 1 = Looking for a job change (predicting '1')

#Drop 'enrollee_id' and 'city' variables
aug = aug[,-c(1,2)]

#check the data 
str(aug)

#Near-zero variance variables
near_zero = nearZeroVar(aug)
near_zero

#The 'major_discipline' variable has near-zero variance- remove it
aug = aug[,-6]
str(aug) #19158 obs & 11 variables

#Check to see if any class imbalances exist- there are some class imbalances but we'll proceed w/caution
table(aug$gender)

table(aug$relevent_experience)

                                           
table(aug$enrolled_university)

#Barplots to show variables w/class imbalances
par(mfrow=c(2,2))

#Gender
barplot(table(aug$gender),main="Barplot of Gender",
        xlab="Gender Type",
        ylab="Count",
        col="black")

#Relevant Experience
barplot(table(aug$relevent_experience),main="Barplot of Relevant Experience",
        xlab="Relevant Experience",
        ylab="Count",
        col="black")

#Education Level
barplot(table(aug$education_level),main="Barplot of Education Level",
        xlab="Education Level",
        ylab="Count",
        col="black")
#University Enrollment
barplot(table(aug$enrolled_university),main="Barplot of University Enrollment",
        xlab="Enrollment Type",
        ylab="Count",
        names.arg=c("Full time course"="Full time", "no_enrollment"="No enrollment", "Part time course"="Part time"),
        col="black")

#Change graph fit back
par(mfrow=c(1,1))

#See if variables have NAs
sapply(aug, function(x) sum(is.na(x)))

#Change NAs to 'Other' for 'gender' variable
aug$gender[is.na(aug$gender)] <- "Other"
table(aug$gender)

#Change NAs to 'no_enrollment' for 'enrolled_university' variable
aug$enrolled_university[is.na(aug$enrolled_university)] <- "no_enrollment"
table(aug$enrolled_university)

#Use mode imputation for 'education_level', 'experience', 'company_size', 'company_type', & 
#'last_new_job' variables
c1<-makePSOCKcluster(3)
registerDoParallel(c1)
aug = VIM::kNN(aug, k = 10, numFun = mode)
aug = aug[,-c(12:22)]
str(aug)
sapply(aug, function(x) sum(is.na(x))) #no more NAs


#Change levels for certain variables

#Change 'education_level' levels
aug$education_level = ifelse(aug$education_level == "Graduate" | aug$education_level == "Masters" | aug$education_level == "Phd", 1, 0)
aug$education_level[aug$education_level == 1] <- "University"
aug$education_level[aug$education_level == 0] <- "Other"
aug$education_level = as.factor(aug$education_level)
levels(aug$education_level)
table(aug$education_level) 
#count: 1/uni = 16669, 0/other = 2489

#Change 'experience' levels
levels(aug$experience) <- list("Some Experience"=c("<1","1","2","3","4"), "Experience"=c("5","6","7","8","9","10","11","12","13","14"), "A lot of Experience"=c("15","16","17","18","19","20",">20"))
str(aug$experience)
table(aug$experience)
#count: Some Experience = 4981, Experience = 8606, A lot of Experience = 5571

#Change 'company_size' levels
levels(aug$company_size) <- list("Small"=c("<10","10/49","50-99","100-500"), "Medium"=c("500-999","1000-4999"), "Large"=c("5000-9999","10000+"))
str(aug$company_size)
table(aug$company_size)
#count: Small = 13000, Medium = 2704, Large = 3454

#Change 'company_type' levels
levels(aug$company_type) <- list("Public"=c("Public Sector"), "Startup"=c("Early Stage Startup","Funded Startup"), "Other"=c("Other","NGO","Pvt Ltd"))
str(aug$company_type)
table(aug$company_type)
#count: Public = 1138, Startup = 1690, Other = 16330

#Change 'last_new_job' levels
levels(aug$last_new_job) <- list("Never"=c("never"), "Recent"=c("1","2"), "Kind of Recent"=c("3","4"), "Not Recent"=c(">4"))
str(aug$last_new_job)
table(aug$last_new_job)
#count: Never = 2554, Recent = 11220, Kind of Recent = 2058, Not Recent = 3336


#Make 'city_development_index' out of 100 for better coefficient interpretation (logistic reg)
aug$city_development_index = 100*(aug$city_development_index)

# Train and Test Split #

#Inspect data before splitting
str(aug) #19158 obs & 11 variables

#Check to see which level we're predicting
levels(aug$target)
#reference = "0" (Not looking for job change), predicting = "1" (Looking for job change)

#Split data into 60% train, 25% validation and 15% test
set.seed(100)
splitSample <- sample(1:3, size=nrow(aug), prob = c(0.6,0.25,0.15), replace = TRUE)
aug.train <- aug[splitSample == 1,]
aug.validation <- aug[splitSample==2,]
aug.test <- aug[splitSample==3,]

#Using SMOTE 

#Inspect data before using SMOTE
str(aug.train) #11555 obs & 11 variables
str(aug.validation) #4800 obs & 11 variables
str(aug.test) #2803 obs & 11 variables

#Use SMOTE for train and test data
set.seed(100)
#Train
aug.train <- SMOTE(target ~ ., data = aug.train)                       
table(aug.train$target) #
#Valid
aug.valid <- SMOTE(target ~ ., data = aug.validation)                         
table(aug.validation$target)
#Test
aug.test <- SMOTE(target ~ ., data = aug.test)                         
table(aug.test$target)

install.packages("corrgram")
install.packages("corrplot")
require(corrgram)
corrgram(aug, order = TRUE)


library(corrplot)
library(RColorBrewer)
M <-cor(aug[2:11])
corrplot(M, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))
corrplot(M, type="upper", order="hclust")

type(loan_data)













