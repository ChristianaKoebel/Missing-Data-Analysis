# Missing Data Analysis

In statistics, researchers often encounter datasets with missing values. Data can be missing for various reasons, such as item non-response. If missing values are handled improperly, biased estimates can be produced, which leads to inaccurate conclusions. The purpose of this project is to analyze a dataset with a significant number of missing values, apply techniques to deal with missing data, and answer the research question outlined below.

The dataset used in this report comes from the Duke University Cardiovascular Disease Databank and was obtained from http://biostat.mc.vanderbilt.edu/DataSets. It consists of data collected from 3504 patients who were sent to the Duke University Medical Center due to chest pain. The variables in the dataset are:

- sex (sex = 1 for female; sex = 0 for male)
- age (in years)
- cad.dur (duration of symptoms of coronary artery disease)
- cholesterol
- sigz (sigdz = 1 if patient has significant coronary disease; sigdz = 0 otherwise)

Although this dataset has 3504 observations, there are 1246 patients whose cholesterol measurements are missing (approximately 36%). 

This analysis aims to answer the research question: For the patients who were referred to Duke Medical Center for chest pain, what are the odds of developing significant coronary disease given sex, age, duration of symptoms, and cholesterol level? Furthermore, the analysis determines if these variables are significantly associated with the disease.

Since 36% of cholesterol values are missing, techniques to deal with missing data are applied: listwise deletion, inverse probability weighting, single imputation (mean, conditional mean, and regression imputation {random forest}), as well as multiple imputation. The regression models and main results of each analysis are discussed, and the missing data techniques are compared.

Click [here](https://github.com/ChristianaKoebel/Missing-Data-Analysis/blob/master/stat_analysis_missing_data.pdf) for the full report (the R code and output can be found in the appendices). See [rcode.R](https://github.com/ChristianaKoebel/Statistical-Analysis-Dealing-With-Missing-Data/blob/master/rcode.R) for the R file and [acath.csv](https://github.com/ChristianaKoebel/Statistical-Analysis-Dealing-With-Missing-Data/blob/master/acath.csv) for the data.
