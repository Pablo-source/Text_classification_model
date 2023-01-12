## TEXTRECIPES PACKAGE

# PARALLEL PROCESSING R SCRIPT
# 02 PARALLEL PROCESSING.R

# Based on a a YouTube video from Andrew Couch
# TidyTuesday: Improving Model Train Times with TidyModels
# https://www.youtube.com/watch?v=MVQExXGooaM&t=187s

# Sections
# 1. Load .csv data
# 2. Summarize Dialogue by character
# 3. Address class imbalance  
# 4. Create initial train test split
# 5. Build matrix to count number of words by character
# 5.1 Apply naive tokenization to our TRAIN and TEST sets 
# 6. PRE-PROCESSING
# 6.1. Tokenization
# 6.2. Remove stop-words
# 6.3. Create a token folder whre max_tokens is (75)
# 6.4. Then we compute the tfidf() algorithm
# 7. MODEL FITTING
# 7.1 Simple model: Elastic net model.
# 7.2 Complex model. XGBOOST MODEL. This is a specific type of TREE model
### 8. MODEL PARAMETERS TUNING
# 8.1 Elastic model parameters tuning
# 8.2 XGBOOST model parameters tuning 
### 9. Start Tunning the models
# 9.1 Compare data structures using a regular gird 
# 9.2 tokenize all these words, and convert them into a matrix
# 9.3 Tune both models
## 9.4 Compare expensive pre-processing to normal pre-processing
# 10 Bayesian customization
# You don't use a grid, instead you use a Bayesian approach
# 11 PARALLEL PROCESSING

# Load required packages
# ("tidyverse", "tidymodels", "textrecipes", "themis")
my_packages <- c("tidyverse", "tidymodels", "tidytext", "textrecipes", "themis")
lapply(my_packages, require, character.only = TRUE)    # Load multiple packages

# Get details of installed packages
ip = as.data.frame(installed.packages()[,c(1,3:4)])
ip = ip[is.na(ip$Priority),1:2,drop=FALSE]
ip

# 1. Load dataset
Input_data <- read_csv("data/harrypottertext.csv")
Input_data

# > Input_data
# A tibble: 8,041 × 4
# Movie          Character   House      Dialogue                                
# <chr>          <chr>       <chr>      <chr>                                   
#  1 Sorcerer_stone Movie_Albus Gryffindor "Ah, Professor, I would trust Hagrid wi…
#  2 Sorcerer_stone Movie_Draco Slytherin  "It's true then, what they're saying on…
#  3 Sorcerer_stone Movie_Draco Slytherin  "Up! {broomstick flies up and Draco smu…
#  4 Sorcerer_stone Movie_Draco Slytherin  "{snickers} Did you see his face? Maybe…
#  5 Sorcerer_stone Movie_Draco Slytherin  "No. I think I'll leave it somewhere fo…
#  6 Sorcerer_stone Movie_Draco Slytherin  "Is that so? {Harry makes a dash for hi…
#  7 Sorcerer_stone Movie_Draco Slytherin  "Wingardium Levio-saaa."                
#  8 Sorcerer_stone Movie_Draco Slytherin  "No!"                                   
#  9 Sorcerer_stone Movie_Draco Slytherin  "Excuse me, Professor. Perhaps I heard …
#  10 Sorcerer_stone Movie_Draco Slytherin  "The forest? I thought that was a joke!…
#  # … with 8,031 more rows

# Start: summarize dialogue by character   

# 2. Summarize Dialogue by character
# And by using strings::str_c()  we combine all quotes into a single line per character.
df <- Input_data %>% 
  select(House, Character, Dialogue) %>% 
  group_by(House,Character) %>% 
  summarise(text = str_c(Dialogue, sep = " ",collapse = " ")) %>% 
  ungroup() %>% 
  filter(House != "No Entry") # remove no entries for House variable
df

# Check house values
House_values <- df %>%
  select(House) %>% 
  group_by(House)  %>%
  summarize( freq = n()) %>% 
  arrange(desc(freq))
House_values

# 3. Address class imbalance  

### 3.1 Class unbalance 

# We have noticed we have class imbalance in our data set from the **House** variable. 
# As we can see below Grynffindor with 90 rows represents 37% of the Houses, Slytherin (28,27%),
# Ravenclaw (18,18%),Hufflepuff(13,12%),Beauxbatons (3,3%),Durmstrang (1,0.1%).

# We have noticed we have class imbalance in our data set from the **House** variable
# The class imbalance refers to variable House taking most of its values for Gryffindor house
df2 <- recipe(House~., data = df) %>% 
  step_upsample(House) %>% 
  prep() %>% 
  juice() %>% 
  mutate (text = as.character(text))
df2

# Balanced values (this is just to check the data set has been balanced)
# We balance the entire data set towards the House value using step_upsample() function. 
# We also use this recipe() function in this step
Balanced_values <- df2 %>% 
  select(House)  %>%
  group_by(House)  %>%
  summarize( freq = n()) %>% 
  arrange(desc(freq))
Balanced_values

### 4. Create initial train test split
set.seed(20)
data_split <- initial_split(df2, prop = .8, strata = House)
data_train <- training(data_split)
data_test <- testing(data_split)
train_k_folds <- vfold_cv(data_train)


### 5. Build matrix to count number of words by character
library(tidyverse)
library(tidymodels)
#install.packages("tidytext",dependencies=TRUE)
library(tidytext)

# This is a way of calculating how many words each character is saying per sample
# We build it from df2 data set
naive_words_build <- df2 %>% 
  unnest_tokens("word","text","words") %>% 
  count(House,word) %>% 
  anti_join(stop_words) %>% 
  bind_tf_idf(word,House,n) %>% 
  group_by(House) %>% 
  top_n(tf_idf, n = 50) %>% 
  ungroup()
naive_words_build

# Check output data set
naive_words_build

# Clean up previous data frame of words per character
naive_words <- naive_words_build %>% 
  filter(n > 10) %>% 
  select(word) %>% 
  distinct()
naive_words

# 5.1 Apply naive tokenization to our TRAIN and TEST sets  

# Each column correspond to a word that was present in the   "bind_tf_idf(word,House,n) %>%" tf_idf() algorithm. 

#### 5.1.1  Train set tokenization  
# This is a data frame with each ford said by each character split by house
naive_train <- data_train %>% 
  mutate(pk = row_number()) %>% 
  unnest_tokens("word","text","words") %>% 
  count(House, pk, word) %>% 
  inner_join(naive_words) %>% 
  pivot_wider(names_from = word, values_from = n, values_fill = 0) %>% 
  select(-pk)
naive_train

#### 5.1.2 Test set tokenization
naive_test <- data_test %>% 
  mutate(pk = row_number()) %>% 
  unnest_tokens("word","text","words") %>% 
  count(House, pk, word) %>% 
  inner_join(naive_words) %>% 
  pivot_wider(names_from = word, values_from = n, values_fill = 0) %>% 
  select(-pk)
naive_test  

## 5.2 Compute the naive_k_folds model on the train set
naive_k_folds_data <- vfold_cv(naive_train)
naive_k_folds_data

# 6. PRE-PROCESSING
# 1. Tokenization
# 2. Remove stop-words
# 3. Create a token folder whre max_tokens is (75)
# 4. Then we compute the tfidf() algorithm

# First we do some **tokenization**: - A token is a meaningful unit of text, such a word, 
# we are interested in using for analysis. So tokenization is the process of splitting text into tokens,
# into single blocks of analysis made up of individual words.

# We use the recipes package to perform all the steps required in this tokenization stage of the analysis.
# **IMPORTANT**: The pre processing will be conducted on the variables "House" and "text"

# Pre-processing in any text analysis: a. Tokenization, b.Removing stop words, c. Set max tokens, d. finally compute tfidf score
text_rec <- recipe(House ~ text, data = data_train) %>% 
  step_tokenize(text) %>% 
  step_stopwords(text) %>% 
  step_tokenfilter(text, max_tokens = 75) %>% 
  step_tfidf(text)

# Expensive Pre-processing. It counts every time it founds a matching term
exp_rec <- recipe(House ~ text, data = data_train) %>% 
  step_tokenize(text) %>% 
  step_stopwords(text) %>% 
  step_tokenfilter(text, max_tokens = 100)  %>% 
  step_tfidf(text) %>% 
  # we add step_isomap(), it is like a costing algorithm
  step_isomap(all_predictors())

# 7 MODEL FITTING

# We always start by using a simple model

# 7.1 Simple model: Elastic net model. IT is an original lasso-regression model, where on top of that 
# you penalize some terms to be zero
elastic_model <- multinom_reg(penalty = tune(), mixture = tune()) %>% 
  set_engine("glmnet") %>% 
  set_mode("classification")

# 7.2 Complex model. XGBOOST MODEL. This is a specific type of TREE model
xgboost_model <- boost_tree (trees = tune(), tree_depth = tune()) %>% 
  set_engine("xgboost") %>% 
  set_mode("classification")

### 8. Model parameters tuning 

# Important to remember that parameters(model) was depreciated in tune 0.1.6.9003, 
# we use hardhat::extract_parameter_set_dials() instead from newly available dials package.

# 8.1 Elastic model parameters tuning
# Elastic model parameters tuning using grid_regular() for grid_regular parameters and grid_max_entropy() 
# for max_entropy() parameters
# Elastic model grid parameters
# Hardhat package (extract_parameter_set_dials() function: returns a set of dials parameter objects 
# extract_parameter_set_dials() returns a set of dials parameter objects.


# # S3 method for parameters; grid_regular()
# 8.1.1 elastic grid_regular() set of parameters chosen using dials package  
elastic_grid <- hardhat::extract_parameter_set_dials(elastic_model) %>% grid_regular()
elastic_grid

# Check which grid of tuning parameters dials package has chosen for the elastic_model grid_regular grids of tuning parameters
Elastic_grids_regular_params <- grid_regular(extract_parameter_set_dials(elastic_model))
Elastic_grids_regular_params

# Elastic model entropy parameters
# Experimental designs for computer experiments are used to construct parameter 
# grids that try to cover the parameter space such that any portion of the space has an observed combination that is not too far from it.

# 8.1.2 elastic grid_ma_entropy() set of parameters chosen using dials package 
elastic_entropy <- hardhat::extract_parameter_set_dials(elastic_model) %>% grid_max_entropy()
elastic_entropy

# Check which grid of tuning parameters dials package has chosen for the elastic_model grid_max_entropy grids of tuning parameters
Elastic__max_grid_entropy_params <- grid_max_entropy(extract_parameter_set_dials(elastic_model))
Elastic__max_grid_entropy_params

# 8.2 XGBOOST model parameters tuning 
# 8.2.1 regular_grid
# Decision tree model with depth 1. It is like a generic decision tree
xgboost_grid  <- hardhat::extract_parameter_set_dials(xgboost_model) %>% grid_regular(filter=c(trees > 1 & tree_depth >1))
xgboost_grid

# Check which grid of tuning parameters dials package has chosen for XGBOOST grid_regular grids of tuning parameters
XGBOOST_grid_regular_params <- grid_regular(extract_parameter_set_dials(xgboost_model))
XGBOOST_grid_regular_params

# 8.2.2 max entropy_grid
xgboost_entropy_grid <- hardhat::extract_parameter_set_dials(xgboost_model) %>% grid_max_entropy()
xgboost_entropy_grid

# Check which grid of tuning parameters dials package has chosen for XGBOOST grid_regular grids of tuning parameters
XGBOOST_grid_max_entropy_params  <- grid_regular(extract_parameter_set_dials(xgboost_model))
XGBOOST_grid_max_entropy_params

# Check parameters for each model (9:03 in the video)
elastic_grid    # Compares parameters in sequential order
Elastic__max_grid_entropy_params
elastic_entropy  # It uses a diverse paring of parameters that are NOT in sequential order
XGBOOST_grid_regular_params
XGBOOST_grid_max_entropy_params

### 9. Start Tunning the models
### 9.1 Compare data structures using a regular gird (video 11:35)
naive_wf <- workflow() %>% 
  add_model(elastic_model) %>% 
  add_formula(House~.)

## This is going to be a matrix instead of a Tibble
# They use default_recipe_blueprint(composition = "dgCMatrix") from hardhat package to turn it into a matrix
library(hardhat)
sparse_bp <- default_recipe_blueprint(composition = "dgCMatrix")

## 9.2 tokenize all these words, and convert them into a matrix
correct_wf <- workflow() %>% 
  add_model(elastic_model) %>% 
  add_recipe(text_rec, blueprint = sparse_bp)

## 9.3 Tune both models

# 9.3.1 Tune elastic model and time how long it takes
# Model: naive_wf
begin <- Sys.time()
naive_res <- tune_grid(naive_wf,
                       grid = elastic_grid,
                       resamples = naive_k_folds_data)

end1 <- Sys.time() - begin
Tune_elastic_timing <-  Sys.time() - begin

# 9.3.2 Tune model we have turned into a matrix and time how long it takes
# sparse_bp (model we have turned into a matrix)
begin <-Sys.time()
correct_res <- tune_grid(correct_wf,
                         grid = elastic_grid,
                         resamples = train_k_folds)
end2 <- Sys.time() - begin
Tune_correct_timing <-  Sys.time() - begin

## 9.4 Compare expensive pre-processing to normal pre-processing
expensive_wf <- workflow() %>% 
  add_model(elastic_model) %>% 
  # Here we add the more expensive recipe
  add_recipe(exp_rec, blueprint = sparse_bp)

# train time for this expensive pre-processing
begin <- Sys.time()

expensive_res <- tune_grid(expensive_wf,
                           grid = elastic_grid, 
                           resamples = train_k_folds)
end3 <- Sys.time() - begin
Tune_expensive_res <-  Sys.time() - begin


# 10 A different way of tuning your model
# Bayesian model
# This time you don't provide your model with a parameter grid
# You don't use a grid, instead you use a Bayesian approach
# When this model doesn't improve further after several re samples, it stops training

begin <- Sys.time()
bayes_res <- tune_bayes(
  correct_wf,
  resamples = train_k_folds,
  control = control_bayes(no_improve = 3, verbose = TRUE)
)
end4 <- Sys.time() - begin
Tune_bayes_res <-  Sys.time() - begin

# 11 PARALLEL PROCESSING
# Start by loading "doParallel" library
# References
# https://cran.r-project.org/web/packages/doParallel/vignettes/gettingstartedParallel.pdf


# doParallel package
# Function: makeCluster{parallel}
# Create a Parallel Scocket Cluster
# Description
# Creates a set of copies of R running in parallel and communicating over sockets

# makePSOCKcluster() function
# makePSOCKcluster(names, ...)
# makePSOCKcluster is an enhanced version of makeSOCKcluster in package snow. It runs Rscript on the specified host(s) to set up a worker process which listens on a socket for expressions to evaluate, and returns the results (as serialized objects).
# names: Either a character vector of host names on which to run the worker copies of R, 
#        or a positive integer (in which case that number of copies is run on localhost).
# We choose to run 4 copies of R


# To register doParallel to be used with foreach, you must call the registerDoParallel function.
# If you call this with no arguments, on Windows you will get three workers and on Unix-like systems
# you will get a number of workers equal to approximately half the number of cores on your system

library(doParallel)

cl <- makePSOCKcluster(4)
cl <- registerDoParallel(cl)

# Compare parallel processing
begin <- Sys.time()

# It is a tune grid, so we use control_grid()
tune_grid(correct_wf,
          grid = elastic_grid,
          resamples = train_k_folds,
          control = control_grid(allow_par = TRUE, parallel_over = "everything"))

end5 <- Sys.time() - begin
end5
# Time difference of 10.17503 secs