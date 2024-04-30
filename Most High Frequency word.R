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
data <- read_excel("Path/Reviews.xlsx")


# stop_words and special characters removing
stp_words <- get_stopwords()
data_new <- data %>%
  unnest_tokens(output = word,input =  Review) %>%
  anti_join(stop_words, by = "word") %>%
  filter(str_detect(word, "[:alpha:]"))%>%
  distinct()


# Create the High Frequency Graph with improved data labels
data_count<- data_new%>%
  count(word, name = "n")%>%
  filter(n> 274, sort(TRUE))
data_count <- data_count %>%
  mutate(word = factor(word, levels = word[order(-n)]))

High_Frequency_graph <- ggplot(data_count, aes(x = word, y = n)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black", size = 1) +
  geom_text(aes(label = n), position = position_stack(vjust = 0.5), size = 3, color = "black", fontface = "bold") +
  labs(title = "Most High Frequent Word",
       x = "Words",
       y = "Frequency") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, margin = margin(b = 20)),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), size = 3, color = 'black', fontface = "bold") # Adjust title position and margin

# Show the graph
print(High_Frequency_graph)
