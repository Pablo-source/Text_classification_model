## 05 TRAINING FORECASTING MODELS

# There are several forecasting applications we can use within the TSstudio package

# 1. Split initial AE

library(TSstudio)
library(tidyverse) 

# Display correlation analysis in a new plot
ts_cor(AE_major_ts)

# Split initial AE_majot_ts into TRAIN, TEST sets

AE_major_ts_split <- ts_split(
  ts.obj = AE_major_ts, sample.out = 12)

train <- AE_major_ts_split$train
test <- AE_major_ts_split$test

# Write Tain and Test splits into a new Train_Test_split folder
if(!dir.exists("Train_Test_split")){dir.create("Train_Test_split")} 

library(here)
here()
write.csv(train,here("ARIMA_model","Train_test_split","AE_TYPEI_train.csv"), row.names = TRUE)
write.csv(test,here("ARIMA_model","Train_test_split","AE_TYPEI_test.csv"), row.names = TRUE)


