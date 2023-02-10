
library(TSstudio)
library(tidyverse) 

# Forecasting with auto.arima
# we use previous train and test sets we defined in the previous script

library(forecast)
md <- auto.arima(train)
fc <- forecast(md, h = 12)

# Plotting actual vs. fitted and forecasted
test_forecast(actual = USgas, forecast.obj = fc, test = test)