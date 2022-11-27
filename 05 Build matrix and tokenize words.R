## TEXTRECIPES library

# PARALLEL PROCESSING  SCRIPT

## TEXTRECIPES library

# PARALLEL PROCESSING FULL SCRIPT

### 5. Build matrix to count number of words by character
library(tidyverse)
library(tidymodels)
#install.packages("tidytext",dependencies=TRUE)
library(tidytext)

# This is a way of calculating how many words each character is saying per sample
# We build it from df2 data set
naive_words_build <- df2 %>% 
  unnest_tokens("word","text","words") %>% 
  count(House,word) %>% 
  anti_join(stop_words) %>% 
  bind_tf_idf(word,House,n) %>% 
  group_by(House) %>% 
  top_n(tf_idf, n = 150) %>% 
  ungroup()
naive_words_build

# Check output data set
naive_words_build

# Clean up previous data frame of words per character
naive_words <- naive_words_build %>% 
  filter(n > 10) %>% 
  select(word) %>% 
  distinct()
naive_words

# 5.1 Apply naive tokenization to our TRAIN and TEST sets  

# Each column correspond to a word that was present in the   "bind_tf_idf(word,House,n) %>%" tf_idf() algorithm. 

#### 5.1.1  Train set tokenization  
# This is a data frame with each ford said by each character split by house
naive_train <- data_train %>% 
  mutate(pk = row_number()) %>% 
  unnest_tokens("word","text","words") %>% 
  count(House, pk, word) %>% 
  inner_join(naive_words) %>% 
  pivot_wider(names_from = word, values_from = n, values_fill = 0) %>% 
  select(-pk)
naive_train

#### 5.1.2 Test set tokenization
naive_test <- data_test %>% 
  mutate(pk = row_number()) %>% 
  unnest_tokens("word","text","words") %>% 
  count(House, pk, word) %>% 
  inner_join(naive_words) %>% 
  pivot_wider(names_from = word, values_from = n, values_fill = 0) %>% 
  select(-pk)
naive_test  

## 5.2 Compute the naive_k_folds model on the train set
naive_k_folds_data <- vfold_cv(naive_train)
naive_k_folds_data
