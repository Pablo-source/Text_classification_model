
library(TSstudio)
library(tidyverse) 

# Forecasting with auto.arima
# we use previous train and test sets we defined in the previous script

library(forecast)
md <- auto.arima(train)
fc <- forecast(md, h = 12)

# Plotting actual vs. fitted and forecasted
test_forecast(actual = AE_major_ts, forecast.obj = fc, test = test)

# It is important to remember that the different plots from TSstudio library are interactive plotly plots. 
# Users can hover and interrogate the chart and data interactively