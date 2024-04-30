
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

## sentiment grading 

afinn <- get_sentiments("afinn")

word_sentiment <- data_new %>%
  inner_join(afinn, by ='word')


count_word_sentiment <- word_sentiment%>%
  count(value, name = "n")


# Create the sentiment graph with improved data labels
sentiment_graph <- ggplot(count_word_sentiment, aes(x = factor(value), y = n)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black", size = 1) +
  geom_text(aes(label = n), position = position_stack(vjust = 0.5), size = 3, color = "black", fontface = "bold") +
  labs(title = "Aurangabad Hotel Review Sentiment",
       x = "Sentiment Grade",
       y = "Frequency") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, margin = margin(b = 20))) # Adjust title position and margin

# Show the graph
print(sentiment_graph)