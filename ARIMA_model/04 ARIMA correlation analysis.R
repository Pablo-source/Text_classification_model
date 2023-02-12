## 04 ARIMA correlation analysis

# This section will also use the "AE_major_ts" data set to explore the ACF and PACF plots. 
# So assess seasonal lags in the TS data
# ts_heatmap(AE_major_ts)

library(TSstudio)
library(tidyverse) 

# Display correlation analysis 

ts_cor(AE_major_ts)

## 05 Lag plots
# We can plot on which lag there is strong correlation to re-affirm what we can
# observe in the ACF and PACF plots
ts_lags(AE_major_ts, lags = 1:12)

## 06 Seasonal lags plot
# Seasonal lags plot
# We specify how many lags we want to analyse in our script
ts_lags(AE_major_ts, lags = c(12, 24, 36, 48))