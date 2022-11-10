## TEXTRECIPES library

# This is an example from the textrecipes Github Repo on how to use textrecipes package for pre-processing in 
# text analysis using R

# Source: 
https://github.com/tidymodels/textrecipes


library(recipes)
library(textrecipes)
library(modeldata)

# 1 Get that "tate_text" data from textrecipes package
data("tate_text") # This makes the daat to appear as in (Values, as <promise>)
force(tate_text) # We force the data to be displayed as a data frame using force()

# Now we have a data frame in our Data pane called "tate_text"
str(tate_text)

tibble [4,284 × 5] (S3: tbl_df/tbl/data.frame)
$ id    : num [1:4284] 21926 20472 20474 20473 20513 ...
$ artist: Factor w/ 701 levels "Absalon","Abts, Tomma",..: 1 29 29 29 29 32 41 49 53 57 ...
$ title : chr [1:4284] "Proposals for a Habitat" "Michael" "Geoffrey" "Jake" ...
$ medium: Factor w/ 1033 levels "100 digital prints on paper, ink on paper and wall text",..: 921 288 288 288 567 567 135 1018 561 740 ...
$ year  : num [1:4284] 1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...

head(tate_text)

> head(tate_text)
# A tibble: 6 × 5
id artist             title                   medium                year
<dbl> <fct>              <chr>                   <fct>                <dbl>
  1 21926 Absalon            Proposals for a Habitat Video, monitor or p…  1990
2 20472 Auerbach, Frank    Michael                 Etching on paper      1990
3 20474 Auerbach, Frank    Geoffrey                Etching on paper      1990
4 20473 Auerbach, Frank    Jake                    Etching on paper      1990
5 20513 Auerbach, Frank    To the Studios          Oil paint on canvas   1990
6 21389 Ayres, OBE Gillian Phaëthon                Oil paint on canvas   1990

# This is how we use the textrecipes package
# 
# AIM: Convert a character variable to the TF-IDF of its tokenized words 

# textrecipes : package used for PRE-PROCESSING Of TEXT ANALYSIS IN R
#
# IMPORTANT: The pre processing will be conducted on the variables "medium" and "artist"

#
# Variables: medium and artist
#

# Step 01 : CONVERT A CHARACTER VARIABLE TO THE TF-IDF of its tokenized words
# textrecipes > step_tokenize {textrecipes}. creates a specification of a recipe step that will convert a character predictor into a token variable.
okc_rec <- recipe(~ medium + artist, data = tate_text) %>%
          step_tokenize(medium, artist) 

okc_rec

# Step 02: REMOVE STOPWORDS
# step_stopwords(medium,artist)
# step_stopwords > step_stopwords {textrecipes}. creates a specification of a recipe step that will filter a token variable for stop words
# The output of this step is still a list, we can't use it as a data frame yet
okc_rec <- recipe(~ medium + artist, data = tate_text) %>%
          step_tokenize(medium, artist) %>% 
          step_stopwords(medium,artist)
okc_rec


# STEP 03: LIMIT OUR ANALYSIS TO ONLY THE 10 MOST USED WORDS
#  step_stopwords(medium,artist)
okc_rec <- recipe(~ medium + artist, data = tate_text) %>%
  step_tokenize(medium, artist) %>% 
  step_stopwords(medium,artist) %>% 
  step_tokenfilter(medium, artist, max_tokens = 10)
okc_rec

# STEP 04: Apply step_tfidf() function
# step_tfidf creates a specification of a recipe step that will convert a token variable 
# into multiple variables containing the term frequency-inverse document frequency of tokens.

#  step_tokenfilter(medium, artist, max_tokens = 10) %>%
okc_rec <- recipe(~ medium + artist, data = tate_text) %>%
  step_tokenize(medium, artist) %>% 
  step_stopwords(medium,artist) %>% 
  step_tokenfilter(medium, artist, max_tokens = 10) %>% 
  step_tfidf(medium, artist)
okc_rec

# Final step is to run the prep() part of the recipe to produce the final OUTPUT 
okc_obj <- okc_rec %>%
  prep()

# TO see the output of the preparation we need to bake() it
str(bake(okc_obj,tate_text))