
# 00 Set project folder structure for Targets pipeline project
# To save and store all input and output files for this text classification project
Project_setup <- function(){ 

    if(!dir.exists("data")){dir.create("data")}  
    if(!dir.exists("checks")){dir.create("checks")}
    if(!dir.exists("plots")){dir.create("plots")}
    if(!dir.exists("model")){dir.create("model")}
    if(!dir.exists("archive")){dir.create("archive")}
    if(!dir.exists("documentation")){dir.create("documentation")}
  
}

# Invoke function to create Targets project folder structure

Project_setup()