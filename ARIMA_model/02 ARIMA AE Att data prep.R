# 02 02 ARIMA AE Att data prep
# 02 02 ARIMA AE attendances and admissions data preparation

# 1. Load required packages
pacman::p_load(readxl,here,dplyr,janitor)

AE_xls_files <- list.files(path = "./data", pattern = "xls$")
AE_xls_files

AE_tabs <- excel_sheets(here("data","AE_England_data.xls"))
AE_tabs

# readxl package, read_excel() function parameters

# Parameters
# sheet = number [Number of sheet to be imported]
# skiep = number [Number of rows from the top of the file to be skipped when importing data into Excel]
# range = "C10:F18" [Range of rows from a specific sheet to be Imported into R]
# na = ""   [How missing values are defined in the input file "-", "#" ]

# 2. Import AE Attendances data

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

# 3. Then we rename remaining variables to shorten their names.

# SUbset Attendances data to produce our first plot
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

