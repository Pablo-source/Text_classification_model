## TEXTRECIPES library

# PARALLEL PROCESSING  SCRIPT

## TEXTRECIPES library

# 7 MODEL FITTING

# We always start by using a simple model

# Using parsnip package, we can define the engine and the mode
# set_mode() parameter: A character string for the model type (e.g "classification)
# It can also be used for other type of models such as regression models set_mode("regression")

# 7.1 Simple model: Elastic net model. IT is an original lasso-regression model, where on top of that 
# you penalize some terms to be zero

elastic_model <- multinom_reg(penalty = tune(), mixture = tune()) %>% 
  set_engine("glmnet") %>% 
  set_mode("classification")

# 7.2 Complex model. XGBOOST MODEL. This is a specific type of TREE model
xgboost_model <- boost_tree (trees = tune(), tree_depth = tune()) %>% 
  set_engine("xgboost") %>% 
  set_mode("classification")
