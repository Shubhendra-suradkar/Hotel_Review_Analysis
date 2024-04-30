## install.packages("ggraph")

library("readxl")
library("tm")
library("tidytext")
library("dplyr")
library("igraph")
library("tidyr")
library("ggraph")


data <- read_excel("C:/Users/KraCo0P/OneDrive/Desktop/trash/new/data/partial ready data/Reviews - Copy.xlsx")

document <- Corpus(VectorSource(data))

#Cleaning

remove_specific_words <- function(x) {
  x <- removeWords(x, c("raj", "panchavati", "raviraj",  "rama", "international", "kailash", "grand"))
  return(x)
}




document <- tm_map(document, content_transformer(tolower))
document <- tm_map(document, remove_specific_words)
document <- tm_map(document, removeNumbers)
document <- tm_map(document, removeWords, stopwords("english"))
document <- tm_map(document, removePunctuation)

df <-  data.frame(text = sapply(document, as.character),
                  stringsAsFactors = FALSE)

# creating Bigrams

New_bigram <- df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2 )
New_bigram

# Count Bigram frequency
New_bigram %>%
  count(bigram, sort = TRUE)

# Seperate Bigram and Remove stop words
bigrams_seperated <- New_bigram %>% 
  separate(bigram,  c("word1", "word2"),sep = " ")

bigrams_filtered <- bigrams_seperated %>%
  filter(!word1 %in% stop_words$word)%>%
  filter(!word2 %in% stop_words$word)

# new bigram counts
bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)
bigram_counts


# create bigraph 
# use words with a count larger than 30 to find relationship

bigram_graph <-  bigram_counts %>% 
  filter(n > 30 ) %>%
  graph_from_data_frame()


bigram_graph

set.seed(2017)
g <- ggraph(bigram_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() + 
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  ggtitle("Co-occurring Word Relationships in Aurangabad Hotel Reviews") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))  # Center align and make the title bold

print(g)




