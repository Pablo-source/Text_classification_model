![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)
![GitHub all releases](https://img.shields.io/github/downloads/Pablo-source/Targets_pipelines_howto/total?label=Downloads&style=flat-square)
![GitHub language count](https://img.shields.io/github/languages/count/Pablo-source/Targets_pipelines_howto)

# Targets: how to build pipelines in R

This is a new project to practise and learn how to use Targets package to automate pipelines in R. I will start testing it using text classification models and later on with univariate time series models.

It allows us to practise several skills: 

- Fuunctions building 
- Model creation
- Pipeline management
- Model fitting and upgrading  

At a later stage in development I will combine the output of this pipeline example with a Shiny dashboard

# Using targets on two models

- 1. Text classification model using elastic and XGBOOST models
- 2. Time Series model using ARIMA to predict 7 days AE Type I Attendances


# Testing a small text classification model using Targets 

The aim of this project is to use  Targets package to setup a small text classification model using Tidymodels and Themis packages.

As a way to learn text classifications models, I will follow this video from Andrew Couch:
- **Andrew Couch** *TidyTuesday: Improving Model Train Times with TidyModels*
- https://www.youtube.com/watch?v=MVQExXGooaM&t=187s

## Classification model using parallel processing analysis steps

1. **Load .csv data**
2. **Summarize Dialogue by character**
3. Address class imbalance  
4. Create initial train test split
5. Build matrix to count number of words by character
- 5.1 Apply naive tokenization to our TRAIN and TEST sets 
6. **PRE-PROCESSING**
- 6.1. Tokenization
- 6.2. Remove stop-words
- 6.3. Create a token folder whre max_tokens is (75)
- 6.4. Then we compute the tfidf() algorithm
7. **MODEL FITTING**
- 7.1 Simple model: Elastic net model.
- 7.2 Complex model. XGBOOST MODEL. This is a specific type of TREE model
8. **MODEL PARAMETERS TUNING**
- 8.1 Elastic model parameters tuning
- 8.1.1 elastic grid_regular() set of parameters chosen using dials package  
- 8.1.2 elastic grid_ma_entropy() set of parameters chosen using dials package 
- 8.2 XGBOOST model parameters tuning 
- 8.2.1 XGBOOST grid_regular() set of parameters chosen using dials package  
- 8.2.2 XGBOOST grid_max_entropy() set of parameters chosen using dials package 
9. Compare data structures from both models using a regular gird 




And in the process I will explore new models and test many of the functions he uses to conduct his analysis

I will use some text examples from Harry Potter books to conducting the analysis, based on several variables from its characters and their text quotes in the book. Tidymodels package is the framework chosen to build a small classification model based on this data.
https://www.kaggle.com/datasets/balabaskar/harry-potter-books-corpora-part-1-7

Classifcation models predicting a class label for a given observation

```mermaid
graph TD;
    Original_text_set-->Train;
    Original_text_set-->Test;
    Train-->Apply_classification_models;
    Test-->Get_model_running_times;
    Train --> Choose_model_based_shortest_time;
    Choose_model_based_shortest_time --> Plot_models_running_times;
```

### Dealing with imbalanced data  
-	When dealing with a classification data set with skewed class proportions is called imbalanced data. 
-	Within this data set we find two types of imbalanced data classes:
-	Classes that make the largest proportion of the data are defined as majority classes
-	Classes that make the smaller proportion are called minority classes
-	Classification model using imbalanced data
-	This is a small example on how to use Targets to create and run a classification predictive model where the distribution of examples across the classes is not equal.

We use Themis package in R to deal with imbalanced data
https://github.com/tidymodels/themis

Themis package makes use of the Recipes package
-	With recipes, you can use DPLYR like pipeable sequences of feature engineering steps to get your data ready for modelling.
- Also we make use of the specific library **textrecipes**, it contain extra steps for the recipes package for preprocessing text data.
https://github.com/tidymodels/textrecipes
-	The easiest way to get recipes is to install all of the tidy models packages
https://www.tidymodels.org/packages/

### Training times model comparison

The aim of this small project was to practise how to tune different models using Tidy models framework. At the end we obtain the different training times depending on the model we have used. 

This plot can be useful in future models to quicly assess model performance
![Models_training_times](https://user-images.githubusercontent.com/76554081/212029051-096854bb-4e0a-4869-b560-5976a391c398.jpeg)

## TS Forecasting model using ARIMA model

### TS seasonality and correlation analysis of AE Attendances Type I data

This second example is a Time Series model using ARIMA to forecast 7 days AE Type I Attendances in England. I will create the model and use Targets to build a pipeline to run it. 

- **TS 01. Start by importing the data and turning it into a TS object**

Using TSstudio library https://ramikrispin.github.io/TSstudio/

library(TSstudio)

ts_plot (AE_major_ts)

![TS_AE_TYPE_I_ATT_AUTOPLOT](https://user-images.githubusercontent.com/76554081/215439850-a7a8ae35-ebb2-4488-bf3a-b83301c75b81.png)

- **TS 02. Check for trend seasonality and other regular patterns**
- Decompose original TS into (Random,Sesonal, Trend, Observed components). Using Additive and multiplicative ts

![TS_decomposition_multi_additive](https://user-images.githubusercontent.com/76554081/216552584-70b88113-d603-43c8-9350-e3fe1dc15e96.png)

- **TS 03. Seasonal plot to check for Seasonality by Frequency Unit and Cycle**

![TS_decomp_Seasonality](https://user-images.githubusercontent.com/76554081/216552754-dd20ff47-8f2d-4880-b78e-69503a41d773.png)

- **TS 04. Heatmap plot describing AE Type I Attendances variation across months for 2010-2019 period**

![Attendances Heatplot](https://user-images.githubusercontent.com/76554081/216664075-806307c3-1702-4bd7-92f3-470f8f6f7e09.png)

- **TS 04. Correlationa analysis** 
- This section will also use the "AE_major_ts" data set to explore the ACF and PACF plots to assess seasonal lags in the TS data

![TS_AE_Type_I_Attendances_ACF_PCF_plots](https://user-images.githubusercontent.com/76554081/218140883-f178c7a5-4b65-417a-865b-03969f672720.png)

- We can plot on which lag there is strong correlation to re-affirm what we can observe in the ACF and PACF plots about the strong seasonality in lag12

![TS_AE_type_I_lag_plots](https://user-images.githubusercontent.com/76554081/218141231-aa9186dc-5929-400f-8ec1-fd773be2fc87.png)

By looking into which plot we observe a linear relationship with previous lag numbers we can assess how many different trend and seasonality patters are present in our AE Type I Attendances data

![TS_AE_TypeI_several_lags_plots](https://user-images.githubusercontent.com/76554081/218141461-72e723fb-a662-4ef4-8fd0-b30d5ff0c253.png)


### ARIMA model using auto.arima() function after initial test train split of AE Attendances Type I data

We use the ts_split() functin to obtain our train and test sets

AE_major_ts_split <- ts_split(
  ts.obj = AE_major_ts, sample.out = 12)

train <- AE_major_ts_split$train
test <- AE_major_ts_split$test

And then we forecast 12 months into the future using ARIMA. The outcome is an **interactive** plotly chart, so it is important to run this code and interact with the chart that the above code produces.

library(forecast)
md <- auto.arima(train)
fc <- forecast(md, h = 12)

# Plotting actual vs. fitted and forecasted
test_forecast(actual = AE_major_ts, forecast.obj = fc, test = test)


![ARIMA_model_AE_ATT_Actual_vs_forecasted](https://user-images.githubusercontent.com/76554081/218144756-c3dea46f-b343-4e4b-bb7d-4eacee6362f5.png)

![ARIMA plotly interactive plot](https://user-images.githubusercontent.com/76554081/218144771-18b9255f-f444-4a82-bed3-03fb494c277d.png)

This is an interactive Plotly chart that can be used to explore RMSE and MAPE accuracy measures as tooltips on top of the standard actual and forecasted values produed by the ARIMA model.
