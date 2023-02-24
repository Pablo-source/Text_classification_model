# 07 ARIMA model

# A&E Attendances and Emergency Admissions

# 1 Load required packages
pacman::p_load(readxl,here,dplyr,janitor) 


# 2. Adhoc function to download  A&E Time Series data from www.england.nhs.uk/statistics website

AE_data <- function()   {
  
  if(!dir.exists("data")){dir.create("data")}
  
  # England-level time series. d
  # Download Excel file to a Project sub-folder called "data", to store results
  # Created previously using an adhoc project structure function
  
  xlsFile = "AE_England_data.xls"
  
  download.file(
    url = 'https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2019/11/Timeseries-monthly-Unadjusted-9kidr.xls',
    destfile = here("data",xlsFile),
    mode ="wb"
  )
  
}

#  3. Read into R Excel file .xls file downloaded from website 
AE_data()

AE_xls_files <- list.files(path = "./data", pattern = "xls$")
AE_xls_files

AE_tabs <- excel_sheets(here("data","AE_England_data.xls"))
AE_tabs


# 3. Subset AE Attendances data from main Excel downloaded file 

AE_data<- read_excel(
  here("data", "AE_England_data.xls"), 
  sheet = 1, skip =17) %>% 
  clean_names()
AE_data

AE_data_Type1_ATT <- read_excel(here("data","AE_England_data.xls"),
                                sheet = 1,skip =17, range = "C18:D123",na = "")
AE_data_Type1_ATT

AE_data_subset<- read_excel(
  here("data", "AE_England_data.xls"), 
  sheet = 1, skip =17) %>% 
  clean_names() %>% 
  select(
    "x1",                                                                      
    "period",                                                                  
    "type_1_departments_major_a_e",                                            
    "type_2_departments_single_specialty",                                     
    "type_3_departments_other_a_e_minor_injury_unit",                          
    "total_attendances" 
  )
AE_data_subset


AE_data_subset_clean <- AE_data_subset %>% select(-x1)
AE_data_subset_clean

# 4. Create a local copy of AE Type I attendances as .csv file 

AE_rename_vars <- AE_data_subset_clean %>% 
  select(
    period,
    type_1_Major_att = type_1_departments_major_a_e,
    type_2_Single_esp_att = type_2_departments_single_specialty,
    type_3_other_att = type_3_departments_other_a_e_minor_injury_unit,
    total_att = total_attendances
  ) 
AE_rename_vars

# 4. Keep type_1_Major attendances for our first ARIMA model . 

AE_major <- AE_rename_vars %>% 
  select (period,
          Major_att = type_1_Major_att)
AE_major

# Write out this subset of data as .csv file
write.csv(AE_major,here("data","AE_Type_1_Major_Att.csv"),row.names=TRUE)


# 5. EXPLORATORY TS ANALYSIS

# 5.1 EDA Exploratory Data Analysis 
AE_major <- AE_rename_vars %>% select (period,Major_att = type_1_Major_att)
AE_major
nrow(AE_major)
# [1] 105
Min_date <- min(AE_major$period)
#[1] "2010-08-01 UTC"
Max_date <- max(AE_major$period)
# [1] "2019-04-01 UTC"

# 01 TS plot 

# save a numeric vector containing 105 AE Type I attendances monthly observations 
# from Aug 2010 to Apr 2019 as a time series object
# In our example or data is monthly so we will adjust frequency to 12
# Start will be Aug 2010 (2010,8)
# End will be Apr 2019 (2019,4)
library(tidyverse)

# 01-01 TS object
AE_major_ts <- ts(AE_major[,2], start = c(2010, 8), end = c(2019, 4), frequency = 12)
AE_major_ts

# We plot our TS series using autoplot function.  autoplot is part of the ggplot2 library.
# We need a TS object to be included in the autoplot() function
#install.packages("TSstudio")
library(TSstudio)
library(tidyverse)

ts_info(AE_major_ts)


# 01-02 TS plot
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

# 02 TS Decomposition 

# 02-01 Include TS decomposition 
# type	
# Set the type of the seasonal component, 
# can be set to either "additive", "multiplicative" or "both" 
# to compare between the first two options (default set to “additive”)

ts_decompose(AE_major_ts, type = "additive", showline = TRUE)
ts_decompose(AE_major_ts, type = "multiplicative", showline = TRUE)
ts_decompose(AE_major_ts, type = "both", showline = TRUE)

# 03 Seasonal plot

# 03-01 Seasonal plot
ts_seasonal(AE_major_ts, type = "all")

# 03-02 Heatmap plot
# We can also produce a heatmap of the AE_major_ts data set 
ts_heatmap(AE_major_ts)

ggsave("TS_plots/TS_Heatmap.png", width = 6, height = 4)   

## 04 ARIMA correlation analysis

# This section will also use the "AE_major_ts" data set to explore the ACF and PACF plots. 
# So assess seasonal lags in the TS data
# ts_heatmap(AE_major_ts)

library(TSstudio)
library(tidyverse) 

## 05 CORRELATION AND SEASONAL PLOTS

# Display correlation analysis 
ts_cor(AE_major_ts)

## 05-01 Lag plots
# We can plot on which lag there is strong correlation to re-affirm what we can
# observe in the ACF and PACF plots
ts_lags(AE_major_ts, lags = 1:12)

## 05-02 Seasonal lags plot
# Seasonal lags plot
# We specify how many lags we want to analyse in our script
ts_lags(AE_major_ts, lags = c(12, 24, 36, 48))


# 6. TS MODELLING 

## TRAINING FORECASTING MODELS

# There are several forecasting applications we can use within the TSstudio package

# 6.1  Split initial AE Attendances data into TRAIN and TEST sets

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


# 6.2 MODEL 01: ARIMA model. USING AUTO.ARIMA() FUNCTION
# Forecasting with auto.arima
# we use previous train and test sets we defined in the previous script

library(forecast)
md <- auto.arima(train)
fc <- forecast(md, h = 12)

# Plotting actual vs. fitted and forecasted
test_forecast(actual = AE_major_ts, forecast.obj = fc, test = test)