# 01 Targets import data.R

###  Harry Potter data sets wrangling to obtain input data for Tidymodel
library(janitor)
library(here)
library(tidyverse)

Path <-here()
Path

# 1 Read in data
# We need to read in characters info and dialogue sentence .csv files 

# 1-2. Characters info
# Characters.csv
# 2-2. Dialogue sentences
# Harry Potter1.csv

# List input .csv files on Data sub-directory
list.files (path = "./data" ,pattern = "csv$")
[1] "Characters.csv"     "Harry Potter 1.csv"


# Load readr library to import data into R
library(readr)

Characters <- read_delim("data/Characters.csv", 
                         delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(Characters)

Quotes <- read_delim("data/Harry Potter 1.csv", 
                         delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(Quotes)

# Now we can merge both datasets
names(Characters)
> names(Characters)
[1] "Id"           "Name"         "Gender"       "Job"          "House"        "Wand"         "Patronus"     "Species"      "Blood status" "Hair colour"  "Eye colour"   "Loyalty"      "Skills"      
[14] "Birth"        "Death" 

names(Quotes)
> names(Quotes)
[1] "Character" "Sentence"

# 2 Subset variables 

# From Charaacters data frame we need to keep "Name" and "House" variables
Char_sel <- Characters %>% select(Name,House)
Char_sel

# From Quotes data frame we need to keep "Character" and "Sentence" variables
# Rename Character as Name
Quotes_sel <- Quotes %>% select(Name = Character,
                                Dialogue = Sentence)
Quotes_sel
 
# Check distinct Names in  Char and Quotes data sets
Names_Char <- Char_sel %>% 
              select(Name) %>% 
              distinct(Name)
Names_Char

write_csv(Names_Char,here("checks","Names_Char.csv"))

Names_Quotes <- Quotes_sel %>% 
              select(Name) %>% 
              distinct(Name)
Names_Quotes

write_csv(Names_Quotes,here("checks","Names_Quotes.csv"))

# CHECKS
Voldemort_q <- Quotes %>% 
               filter(Character==Voldemort)

# 3 Merge by Name
# WE NEED A FINAL DATA SET CONTAIING "Name", "House","Dialogue"
nrow(Names_Char)
[1] 140
nrow(Names_Quotes)
[1] 56
# Merge files using DPLYR. We will add to Char_sel data set all variables from Quotes_sel data set (merging them by "Name")
# We are going to merge these two data sets
Char_sel <- Characters %>% select(Name,House)
Quotes_sel <- Quotes %>% select(Name = Character,Dialogue = Sentence)

# 3.1 First I need to re code variables, better to choose the SHORTEST file to recode and merge with the longest one
# I WILL RECODE NAMES in "Names_Quotes" file
# 1 Check re code in DPLYR 
Name <-c("Juan","Pepe","Enrique")
Age <-c(43,14,54)
Data_test <-cbind.data.frame(Name,Age)

# REcode Data_test Name variable
# DPLYR recode(Variable, Old_name = New_name)
Data_test <- Data_test %>%
            mutate(New_name = recode(Name, 
                                     "Juan" = "John"))
Data_test

# Now we can do the same on the Quotes file
# DPLYR recode(Variable, Old_name = New_name)
# New Name                                    PREVIOUS NAME
# Albus Percival Wulfric Brian Dumbledore	    Dumbledore	x
# Dean Thomas	                                Dean	x
# Draco Malfoy	                              Draco	x
# Dudley Dursley	                            Dudley	x
# Filius Flitwick	                            Flitwick	x
# Firenze	                                    Firenze	x
# Fred Weasley	                              Fred	x
# Garrick Ollivander	                        Ollivander x	
# George Weasley	                            George	x
# Ginevra (Ginny) Molly Weasley	              Ginny	 x
# Harry James Potter  	                      Harry	x
# Hermione Jean Granger	                      Hermione	x
# Lee Jordan 	Lee                             Jordan	x
# Lucius Malfoy	                              Malfoy	x
# Minerva McGonagall	                        McGonagall	x
# Molly Weasley	                              Mrs. Weasley	
# Neville Longbottom	                        Neville	x
# Nicholas de Mimsy-Porpington	              Sir Nicholas	x
# Oliver Wood	                                Oliver	x
# Percy Ignatius Weasley	                    Percy	x
# Petunia Dursley	                            Petunia	x
# Quirinus Quirrell	                          Quirrell	x
# Rolanda Hooch	                              Madam Hooch	
# Ronald Bilius Weasley	                      Ron	
# Seamus Finnigan	                            Seamus	
# Severus Snape	                              Snape	
# Tom Marvolo Riddle	                        Barkeep Tom	
# Vernon Dursley	                            Vernon	

# DPLYR recode(Variable, Previous name = New_name) 
Quotes_sel_new <- Quotes %>%
                        mutate(Name = recode(Character, 
                                         "Dumbledore" = "Albus Percival Wulfric Brian Dumbledore", 
                                         "Dean" = "Dean Thomas",
                                         "Draco"     = "Draco Malfoy",
                                         "Dudley"     = "Dudley Dursley",
                                         "Flitwick"     = "Filius Flitwick",
                                         "Firenze"     = "Firenze",
                                         "Fred"     = "Fred Weasley",
                                         "Ollivander"     = "Garrick Ollivander",
                                         "George"     = "George Weasley",
                                         "Ginny"     = "Ginevra (Ginny) Molly Weasley",
                                         "Harry"     = "Harry James Potter",
                                         "Hermione"     = "Hermione Jean Granger",
                                         "Jordan"     = "Lee Jordan 	Lee",
                                         "Malfoy"     = "Lucius Malfoy",
                                         "McGonagall"     = "Minerva McGonagall",
                                         "Mrs. Weasley"     = "Molly Weasley",
                                         "Neville"     = "Neville Longbottom",
                                         "Sir Nicholas"     = "Nicholas de Mimsy-Porpington",
                                         "Oliver"     = "Oliver Wood	",
                                         "Percy"     = "Percy Ignatius Weasley",
                                         "Petunia"     = "Petunia Dursley",
                                         "Quirrell"     = "Quirinus Quirrell",
                                         "Madam Hooch"     = "Rolanda Hooch",
                                         "Ron"     = "Ronald Bilius Weasley",
                                         "Seamus"     = "Seamus Finnigan",
                                         "Snape"     = "Severus Snape",
                                         "Barkeep Tom"     = "Tom Marvolo Riddle",
                                         "Vernon"     = "Vernon Dursley",
                                         ))
Quotes_sel_new

# Merge them   
head(Char_sel)
head(Quotes_sel_new)

rm(list=ls()[!(ls()%in%c('Char_sel','Quotes_sel_new'))])

names(Char_sel)
#[1] "Name"  "House"
names(Quotes_sel_new)
# [1] "Character" "Sentence"  "Name" 

Quotes_merge <- Quotes_sel_new %>% select(Sentence,Name)

# THEN WE MERGE "Char_sel" data set and "Quotes_merge" by Name
Mydata <- Char_sel %>% 
          left_join(Quotes_merge,by="Name")
Mydata

# THIS IS THE FINAL DATASET WE WILL USE for the text classification model

# save copy of merged data set onto data folder
write.csv(Mydata,here("data","Mydata.csv"), row.names = TRUE)

# ALso save image for backup 
save.image("~/Documents/Pablo_Desktop/R_warehouse/R_projects/R_predictive_models/01 Model_train_Tidy_Models/Tidymodels_01/02 Mydata.RData")


