# Demand forecasting using ARIMA
#Searching for the href HTML tag we can find the corresponding .xls file to import it into R.
#<p><a href="https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2019/11/Timeseries-monthly-Unadjusted-9kidr.xls">Unadjusted: Monthly A&amp;E Time series April 2019 (XLS, 364K)</a><br />


# A&E Attendances and Emergency Admissions
# The Weekly and Monthly A&E Attendances and Emergency Admissions collection collects the total number of attendances in the specified period for all A&E types, including Minor Injury Units and Walk-in Centres, and of these, the number discharged, admitted or transferred within four hours of arrival.
# Also included are the number of Emergency Admissions, and any waits of over four hours for admission following decision to admit.
# Data are shown at provider organisation level, from NHS Trusts, NHS Foundation Trusts and Independent Sector Organisations.

# https://www.england.nhs.uk/statistics/statistical-work-areas/ae-waiting-times-and-activity/

# 1 Import CSV A&E Attendances and Emergency Admissions data downloading it directly from NHS England websie using file URL

# This is an .xls file extension, Excel 97-Excel 2003 Workbook , The Excel 97 - Excel 2003 Binary file format (BIFF8).
# We can import both .xls and .xlsx file using download.file() function from readxl package

pacman::p_load(readxl,here,dplyr,janitor) 

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
# Download A&E data function (no arguments)
AE_data()
<<<<<<< HEAD:ARIMA_model/01 ARIMA model_Import AE data.R

head(AE_data)
=======
>>>>>>> c947c64feeeab0af58579f01ce2db16b5078a0a5:ARIMA_model/02 01 ARIMA model_Import AE data.R
