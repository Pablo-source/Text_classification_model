## 04 ARIMA correlation analysis

# This section will also use the "AE_major_ts" data set to explore the ACF and PACF plots. 
# So assess seasonal lags in the TS data
# ts_heatmap(AE_major_ts)

library(TSstudio)
library(tidyverse)

# Display correlation analysis

ts_cor(AE_major_ts)