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

I will use some text examples from Harry Potter books to conducting the analysis, based on several variables from its characters and their text quotes in the book. Tidymodels package is the framework chosen to build a small classification model based on this data.
https://www.kaggle.com/datasets/balabaskar/harry-potter-books-corpora-part-1-7

# Testing a small text classification model using Targets 
The aim of this project is to use  Targets package to setup a small text classification model using Tidymodels and Themis packages.

Classifcation predictive models involve predicting a class label for a given observation

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
-	The easiest way to get recipes is to install all of the tidy models packages
https://www.tidymodels.org/packages/

