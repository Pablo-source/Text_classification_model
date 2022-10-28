# Run targets example as video

#
# 1. USING STANDARD FUNCTIONS 
#
source("R/functions.R")
# This loads our functions
# 1. Then we can execute each of the functions
file <-"data.csv"

# 1.1 Run the data ingestion function
data <-get_data(file)
data
# This loads the data into our environment
# 1.2 Create model using second function
model <- fit_model(data)
model
# 1.3 We finally plot the model
plot <- plot_model(model,data)
plot


##
# MAKE IT INTO A PIPELINE
# USING use_targets() function
library(targets)
use_targets()

# We have modified _targets.R
# Check for obvious errors
tar_manifest(fields = command)

# Print the natural connected flow
tar_visnetwork()

# RUN THE PIPELINE
tar_make()


# Read PIPELINE outputs
tar_read(plot)

# We can see how the plot is produced

