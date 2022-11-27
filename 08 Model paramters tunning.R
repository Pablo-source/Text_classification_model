## TEXTRECIPES library

# PARALLEL PROCESSING  SCRIPT

## TEXTRECIPES library

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
# 8.2.1 XGBOOST grid_regular() set of parameters chosen using dials package  
xgboost_grid  <- hardhat::extract_parameter_set_dials(xgboost_model) %>% grid_regular(filter=c(trees > 1 & tree_depth >1))
xgboost_grid

# Check which grid of tuning parameters dials package has chosen for XGBOOST grid_regular grids of tuning parameters
XGBOOST_grid_regular_params <- grid_regular(extract_parameter_set_dials(xgboost_model))
XGBOOST_grid_regular_params

# 8.2.2 XGBOOST grid_max_entropy() set of parameters chosen using dials package 
xgboost_entropy_grid <- hardhat::extract_parameter_set_dials(xgboost_model) %>% grid_max_entropy()
xgboost_entropy_grid

# Check which grid of tuning parameters dials package has chosen for XGBOOST grid_regular grids of tuning parameters
XGBOOST_grid_max_entropy_params  <- grid_regular(extract_parameter_set_dials(xgboost_model))
XGBOOST_grid_max_entropy_params

### 9. Compare data structures from both models using a regular gird (9:20)
