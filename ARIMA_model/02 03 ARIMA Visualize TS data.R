# 02 03 Visualize type_1_Major Attendances 

# Keep type_1_Major attendances for our first ARIMA model . 

AE_major <- AE_rename_vars %>% select (period,Major_att = type_1_Major_att)
AE_major

nrow(AE_major)
# [1] 105
Min_date <- min(AE_major$period)
Min_date
#[1] "2010-08-01 UTC"
Max_date <- max(AE_major$period)
Max_date
# [1] "2019-04-01 UTC"
# We have a total of 105 monthly AE Type I attendances observations
# 01. Visualize TS data to identify Seasonality or trends
# Transform AE_Type_I_Major_Attendances into a TS object


# 03.01 TS plot 

# ts function Parameters
# frequency = The number of observations per unit of time
# The “frequency” is the number of observations before the seasonal pattern repeats.1 When using the ts() function in R, the following choices should be used.
# Data	frequency
# Annual	1
# Quarterly	4
# Monthly	12
# Weekly	52

# save a numeric vector containing 105 AE Type I attendances monthly observations 
# from Aug 2010 to Apr 2019 as a time series object
# In our example or data is monthly so we will adjust frequency to 12
# Start will be Aug 2010 (2010,8)
# End will be Apr 2019 (2019,4)
library(tidyverse)

AE_major_ts <- ts(AE_major[,2], start = c(2010, 8), end = c(2019, 4), frequency = 12)
AE_major_ts

# We plot our TS series using autoplot function
# autoplot is part of the ggplot2 library.
# We need a TS object to be intered in the autoplot() function
install.packages("TSstudio")
library(TSstudio)

ts_info(AE_major_ts)

#  The AE_major_ts series is a ts object with 1 variable and 105 observations
# Frequency: 12 
# Start time: 2010 8 
# End time: 2019 4 

ts_plot(AE_major_ts)

# We can customize how the initial TS plot

ts_plot(AE_major_ts,
          title = "AE Type I monthly Attendances.England. Aug 2010, Apr 2019",
        Xtitle = "Date", 
        Ytitle = "Daily Attendances",
        slider = TRUE)

autoplot(AE_major_ts) +
           xlab("Time series") + ylab("Daily Attendances") +
           ggtitle("AE Type I monthly Attendances.England. Aug 2010, Apr 2019") +
           theme(plot.title = element_text(hjust=0.5),
                              panel.grid.major = element_blank(),
                              axis.line = element_line (colour = "blue"))

# 03.02 TS decomposition  
# WIP
