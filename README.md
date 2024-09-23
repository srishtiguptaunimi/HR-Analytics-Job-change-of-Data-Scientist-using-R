# HR Analytics: Predicting Job Change of Data Scientist 

## Overview
This project explores the dynamics behind job changes among data scientists, leveraging HR analytics to uncover patterns and insights that can inform both individuals and organizations. By analyzing a dataset containing various attributes related to data scientists' career choices, we aim to identify key factors influencing job transitions, ultimately providing actionable recommendations for career development and talent management.

## Table of Contents
- [Project Description](#project-description)
- [Data](#data)
- [Objectives](#objectives)
- [Methodology](#methodology)
  - [Data Preprocessing](#data-preprocessing)
  - [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
  - [Modeling Techniques](#modeling-techniques)
- [Results](#results)
- [Conclusion](#conclusion)
- [Future Work](#future-work)

## Project Description
In the rapidly evolving field of data science, understanding the factors that lead professionals to change jobs is crucial for both employees seeking growth and employers aiming to retain talent. This project utilizes a dataset specifically curated for data scientists, encompassing variables such as job satisfaction, salary, work-life balance, and skill sets. By applying statistical analysis and machine learning techniques in R, we aim to paint a comprehensive picture of the job change landscape within this profession.

## Data
The dataset used in this project includes:
- **Demographic Information**: Age, gender, education level.
- **Job Attributes**: Current job title, years of experience, industry.
- **Career Aspirations**: Desired job title, willingness to relocate.
- **Job Satisfaction Metrics**: Salary satisfaction, work-life balance, company culture.

The data is sourced from various platforms and surveys targeting data science professionals.

## Objectives
The primary objectives of this project are:
1. To analyze the key factors influencing job changes among data scientists.
2. To develop predictive models that can forecast potential job transitions based on individual characteristics.
3. To provide insights that can aid organizations in improving employee retention strategies.

## Methodology

### Data Preprocessing
Before analysis, the dataset undergoes rigorous preprocessing steps:
- Handling missing values through imputation techniques.
- Encoding categorical variables for modeling purposes.
- Normalizing numerical features to enhance model performance.

### Exploratory Data Analysis (EDA)
EDA is conducted to visualize relationships within the data:
- **Distribution Analysis**: Understanding how various factors like age and salary are distributed.
- **Correlation Matrix**: Identifying correlations between job satisfaction metrics and job change likelihood.
- **Visualization**: Utilizing R's ggplot2 package to create insightful visualizations that reveal trends and patterns.

### Modeling Techniques
Several modeling approaches are implemented:
1. **Logistic Regression**: To predict the probability of a job change based on various predictors.
2. **Decision Trees**: For interpretability in identifying key decision-making factors.
3. **Random Forests**: To enhance prediction accuracy through ensemble learning techniques.

## Results
The analysis reveals significant insights into the job change behavior of data scientists:
- Key factors influencing job changes include salary satisfaction, work-life balance, and opportunities for career advancement.
- Predictive models demonstrate a high accuracy rate in forecasting job transitions based on individual attributes.

## Conclusion
This project highlights the importance of understanding the motivations behind job changes in the field of data science. The findings not only assist data scientists in making informed career decisions but also provide organizations with valuable insights into employee retention strategies.

## Future Work
Future iterations of this project could explore:
- Expanding the dataset to include more diverse demographics across different regions.
- Incorporating sentiment analysis from social media or professional networking sites to gauge employee sentiment towards their jobs.
- Developing interactive dashboards using Shiny in R for real-time analytics and visualizations.

This repository serves as a comprehensive resource for anyone interested in HR analytics within the context of data science careers. By combining statistical rigor with practical applications, I hope to contribute valuable knowledge to both individuals and organizations navigating this dynamic field.
