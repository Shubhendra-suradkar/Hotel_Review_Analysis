library(textdata)

library(openxlsx)
library(widyr)
library(readxl)
library(tidytext)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(tm)
library(igraph)
library(ggraph)

## pakages 



## data importing
data <- read_excel("C:/Users/KraCo0P/OneDrive/Desktop/trash/new/data/partial ready data/Reviews.xlsx")

stp_words <- get_stopwords()


data_new <- data %>%
  unnest_tokens(output = word,input =  Review) %>%
  anti_join(stop_words, by = "word") %>%
  filter(str_detect(word, "[:alpha:]"))%>%
  distinct()


# def generate word graph
generate_word_graph <-function(data_new,
                               minimum_users_n = 50,
                               minimum_correlation = 0.2) {
  
  user_who_mentioned_word <- data_new %>%
    count(word, name = "users_n")%>%
    filter(users_n >=minimum_users_n)
  
  word_correlations <- data_new %>%
    semi_join(user_who_mentioned_word, by = "word") %>%
    pairwise_cor(item = word, feature = user_id) %>%
    filter(correlation >=minimum_correlation)
  
  graph_from_data_frame(d = word_correlations,
                        vertices = user_who_mentioned_word %>%
                          semi_join(word_correlations, by = c('word'= 'item1')))%>%
    
    ggraph(layout = 'fr') + 
    geom_edge_link(aes(alpha = correlation)) +
    geom_node_point() + 
    geom_node_text(aes(color = users_n, label = name), repel = TRUE)
}

data_new.POSITIVE %>%
  generate_word_graph(minimum_users_n = 10,
                      minimum_correlation = 0.14)
