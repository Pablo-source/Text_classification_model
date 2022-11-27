## TEXTRECIPES library

# PARALLEL PROCESSING  SCRIPT

## TEXTRECIPES library

### 4. Create initial train test split
set.seed(20)
data_split <- initial_split(df2, prop = .8, strata = House)
data_train <- training(data_split)
data_test <- testing(data_split)
train_k_folds <- vfold_cv(data_train)

