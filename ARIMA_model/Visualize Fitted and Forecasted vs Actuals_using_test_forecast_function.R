# Using test_forecast function

# Function:test_forecast()
# Package: TSstudio

if(!require('TSstudio')) {
  install.packages('TSstudio')
  library('TSstudio')
}

library(forecast)
data(USgas)

# Set the horizon of the forecast
h <- 12

# split to training/testing partition
split_ts <- ts_split(USgas, sample.out  = h)
train <- split_ts$train
test <- split_ts$test

# Create forecast object
fc <- forecast(auto.arima(train, lambda = BoxCox.lambda(train)), h = h)

# TEST_FORECAST() FUNCTION EXPLAINED
# test_forecast: Visualize of the Fitted and the Forecasted vs the Actual Values
#Arguments
# actual: The full time series object (supports "ts", "zoo" and "xts" formats)
# forecast.obj: The forecast output of the training set with horizon align to the length of the testing (support forecasted objects from the <U+201C>forecast<U+201D> package)
# train: Training partition, a subset of the first n observation in the series (not requiredthed)
# test: The testing (hold-out) partition
# Ygrid: Logic,show the Y axis grid if set to TRUE
# Xgrid: Logic,show the X axis grid if set to TRUE
# hover: If TRUE add tooltip with information about the model accuracy

# Plot the fitted and forecasted vs the actual values
test_forecast(actual = USgas, forecast.obj = fc, test = test)