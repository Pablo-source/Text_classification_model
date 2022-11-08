# 02 Address unbalanced data Split train test
library(tidyverse) 
library(themis)

# Load previous workspace
load("~/Documents/Pablo_Desktop/R_warehouse/R_projects/R_predictive_models/01 Model_train_Tidy_Models/Tidymodels_01/02 Mydata.RData")

# ### 2. Summarise quotes by character
# We need now to group all quotes for each specific character, by grouping Sentences by each character using DPLYR verbs
# After summarising all quotes for each character, we combine them into a single value using str_c() function


df <- Mydata %>% 
  select(House,Name,Sentence) %>% 
  group_by(House,Name) %>% 
  summarise(text = str_c(Sentence, sep = " ",collapse = " ")) %>% 
  ungroup()
df

# We check first how many empty records are there in House variable
House_values <- Mydata %>%
  select(House) %>% 
  group_by(House)  %>%
  summarize( freq = n()) %>% 
  arrange(desc(freq))
House_values

# As we can see bellow, we need to remove those null values for the house name
# Then we remove house missing values 

df2 <- Mydata %>% 
        select(House,Name,Sentence) %>% 
        group_by(House,Name) %>% 
        summarise(text = str_c(Sentence, sep = " ",collapse = " ")) %>% 
        ungroup() %>% 
        filter(House != "No Entry")
df2

### 3. Class imbalance 
# We have noticed we have class imbalance in our data set from the **House** variable. 
# As we can see below Grynffindor with 38 rows represents 37% of the Houses, Slytherin (28,27%), 
# Ravenclaw (18,18%),Hufflepuff(13,12%),Beauxbatons (3,3%),Durmstrang (1,0.1%).

House_values <- df2 %>% 
                  select(House)  %>%
                  group_by(House)  %>%
                  summarize( freq = n()) %>% 
                  arrange(desc(freq))
House_values

# #### 3.1 How the recipe() function works
# Recipes package is very useful for both **pre-processing** data and **building models** specially if you are building a **pipeline** in R to automate any analysis.
# The Recipes R package is part of the new “tidymodels” package ecosystem
# Include in this section information about the recipe package:
  
-   [recipes website]<https://recipes.tidymodels.org/>
-   [using recipes]<https://www.tmwr.org/recipes.html>
-   [Easy pre-processing]<https://www.rebeccabarter.com/blog/2019-06-06_pre_processing/>

#### 3.2 How the step_upsample() function works
# Many models perform best when the number of observations is equal and, thus, tend to struggle with unbalanced data.
# When a classification data set includes skewed class proportions, it is called *imbalanced*. Classes that make up a large proportion of the data set are called **majority** classes. Those that make up a smaller proportion are **minority** classes
# The Themis package deals with unbalanced data by using two types of approaches: 
  
#  • Ones that remove observations from the majority class(es), and
#  • Ones that add observations to the minority class(es).

# The **step_upsample()** function falls in the second approach, by **adding** observations to the minority class.
# Hybrid-sampling involves adding observations to the minority class. This can be done in multiple ways, one way is to sample existing data points like step_upsample()
# We re-balance the dataset making use of the recipe package as part of the **Tidymovels** universe.
  
df3 <- recipe(House~., data = df2) %>% 
            step_upsample(House) %>% 
            prep() %>% 
            juice() %>% 
            mutate (text = as.character(text))
df3

# To check the effect the step_upsample() have had on the data we can re-run the frequency distribution on this new Balance data set
table(df3$House)

eauxbatons Academy of Magic         Durmstrang Institute 
38                           38 
Gryffindor                   Hufflepuff 
38                           38 
Ravenclaw                    Slytherin 
38                           38 

#It is normal to see the overall number of observations increases from 101 observation in df2 to 228 observations, as the **step_upsample(House)** function increases number of rows. 000

### 3. Creaete initial train test split

# Create initial train test split [initial_split(), rsample package]
# The first step in building any model is to split your original data set into train and test sets
# We create our generic train and test splits

# We load tidymodels library to use initial_split, training() and testing() functions, as well as vfold_cv() functions

# As standard convention we assign 80% of our data to the train Set and 20% to our test set. 

# First we load the tidymodels framework
library(tidymodels)


[rsample website]<https://rsample.tidymodels.org/>

# And we perform the train test split 
# initial_split(): creates a single binary split of the data into training and test sets. Arguments: 
#       prop: proportion data retained for analysis (I follow the 80/20 rule).80% of initial set assigned to Train data and 20% to Test data
#       strata: A variable in the data set used to conduct stratified sampling. Stratified random sampling is done by dividing the entire population into homogeneous groups called strata, 
#               I have used House in the step_upsample() formula, so I choose that same variable for my re-sampling. As we have dealt with unbalanced classess at this stage. 
# I have also split my train data using vfolc_cv() function to perform a v fold cross validation of the train test sampling performed.

set.seed(20)
data_split <- initial_split(df3, prop = .8, strata = House)
data_train <- training(data_split)
data_test <- testing(data_split)
train_k_folds <- vfold_cv(data_train)


