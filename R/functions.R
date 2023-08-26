
# Idea and some source code
# https://books.ropensci.org/targets/walkthrough.html

# functions.R
library(dplyr)
library(ggplot2)
library(tibble)
library(readr)
library(here)

here()
#[1] "/home/pablo/Documents/Pablo_Desktop/R_warehouse/R_projects/TARGETS package 26 May2022"

Project_setup <- function(){
  
  if(!dir.exists("data")){dir.create("data")}  
  if(!dir.exists("checks")){dir.create("checks")}
  if(!dir.exists("plots")){dir.create("plots")}
  if(!dir.exists("model")){dir.create("model")}
  if(!dir.exists("archive")){dir.create("archive")}
  if(!dir.exists("documentation")){dir.create("archive")}
  
}

# Invoke function to create project folder structure
# Project_setup()


get_data <- function (file){
  read_csv(file,col_types = cols()) %>% 
    filer(!is.na(Ozone))
}

fit_model <- function (data){
  lm(Ozone ~ Temp, data) %>% 
    coefficients()
}

plot_model <-function (mode,data){
  ggplot(data) +
    geom_points(aes(x = Temp, y = Ozone)) +
    geom_abline(intercept = model[1], slope = model[2])
}

