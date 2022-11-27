## TEXTRECIPES library

# PARALLEL PROCESSING FULL SCRIPT

# Load required packages
# ("tidyverse", "tidymodels", "textrecipes", "themis")
my_packages <- c("tidyverse", "tidymodels", "tidytext", "textrecipes", "themis")
lapply(my_packages, require, character.only = TRUE)    # Load multiple packages

# 1. Load dataset

Input_data <- read_csv("data/harrypottertext.csv")
Input_data

# > Input_data
# A tibble: 8,041 × 4
# Movie          Character   House      Dialogue                                
# <chr>          <chr>       <chr>      <chr>                                   
#  1 Sorcerer_stone Movie_Albus Gryffindor "Ah, Professor, I would trust Hagrid wi…
#  2 Sorcerer_stone Movie_Draco Slytherin  "It's true then, what they're saying on…
#  3 Sorcerer_stone Movie_Draco Slytherin  "Up! {broomstick flies up and Draco smu…
#  4 Sorcerer_stone Movie_Draco Slytherin  "{snickers} Did you see his face? Maybe…
#  5 Sorcerer_stone Movie_Draco Slytherin  "No. I think I'll leave it somewhere fo…
#  6 Sorcerer_stone Movie_Draco Slytherin  "Is that so? {Harry makes a dash for hi…
#  7 Sorcerer_stone Movie_Draco Slytherin  "Wingardium Levio-saaa."                
#  8 Sorcerer_stone Movie_Draco Slytherin  "No!"                                   
#  9 Sorcerer_stone Movie_Draco Slytherin  "Excuse me, Professor. Perhaps I heard …
#  10 Sorcerer_stone Movie_Draco Slytherin  "The forest? I thought that was a joke!…
#  # … with 8,031 more rows
   
# Start: summarize dialogue by character   

# 2. Summarize Dialogue by character
# And by using strings::str_c()  we combine all quotes into a single line per character.
df <- Input_data %>% 
  select(House, Character, Dialogue) %>% 
  group_by(House,Character) %>% 
  summarise(text = str_c(Dialogue, sep = " ",collapse = " ")) %>% 
  ungroup() %>% 
  filter(House != "No Entry") # remove no entries for House variable
df

# Check house values
House_values <- df %>%
  select(House) %>% 
  group_by(House)  %>%
  summarize( freq = n()) %>% 
  arrange(desc(freq))
House_values
