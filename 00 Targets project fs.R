
##  Created previously a project called TARGETS package.Rproj to contain all project analysis outputs and inputs

# 00 Set project folder structure for Targets pipeline project

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