## TEXTRECIPES library

# PARALLEL PROCESSING  SCRIPT

## TEXTRECIPES library

# 6. PRE-PROCESSING
# 1. Tokenization
# 2. Remove stop-words
# 3. Create a token folder whre max_tokens is (75)
# 4. Then we compute the tfidf() algorithm

# First we do some **tokenization**: - A token is a meaningful unit of text, such a word, 
# we are interested in using for analysis. So tokenization is the process of splitting text into tokens,
# into single blocks of analysis made up of individual words.

# We use the recipes package to perform all the steps required in this tokenization stage of the analysis.
# **IMPORTANT**: The pre processing will be conducted on the variables "House" and "text"

# Pre-processing in any text analysis: a. Tokenization, b.Removing stop words, c. Set max tokens, d. finally compute tfidf score
text_rec <- recipe(House ~ text, data = data_train) %>% 
  step_tokenize(text) %>% 
  step_stopwords(text) %>% 
  step_tokenfilter(text, max_tokens = 75) %>% 
  step_tfidf(text)

# Expensive Pre-processing. It counts every time it founds a matching term
exp_rec <- recipe(House ~ text, data = data_train) %>% 
  step_tokenize(text) %>% 
  step_stopwords(text) %>% 
  step_tokenfilter(text, max_tokens = 100)  %>% 
  step_tfidf(text) %>% 
  # we add step_isomap(), it is like a costing algorithm
  step_isomap(all_predictors())

