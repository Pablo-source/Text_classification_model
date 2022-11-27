## TEXTRECIPES library

# PARALLEL PROCESSING  SCRIPT

# 3. Address class imbalance  

### 3.1 Class unbalance 

# We have noticed we have class imbalance in our data set from the **House** variable. 
# As we can see below Grynffindor with 90 rows represents 37% of the Houses, Slytherin (28,27%),
# Ravenclaw (18,18%),Hufflepuff(13,12%),Beauxbatons (3,3%),Durmstrang (1,0.1%).

# We have noticed we have class imbalance in our data set from the **House** variable
# The class imbalance refers to variable House taking most of its values for Gryffindor house
df2 <- recipe(House~., data = df) %>% 
  step_upsample(House) %>% 
  prep() %>% 
  juice() %>% 
  mutate (text = as.character(text))
df2

# Balanced values (this is just to check the data set has been balanced)
# We balance the entire data set towards the House value using step_upsample() function. 
# We also use this recipe() function in this step
Balanced_values <- df2 %>% 
  select(House)  %>%
  group_by(House)  %>%
  summarize( freq = n()) %>% 
  arrange(desc(freq))
Balanced_values
