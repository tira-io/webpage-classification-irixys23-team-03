library(word2vec)
library(purrr)

prepare_text <- function(text) {
  txt_clean_word2vec(text)
}

embed_text <- function(text, word2vec_model, dim) {
  text <- strsplit(text, " ")

  text_emb <- map(text, ~ predict(word2vec_model, .x, type = "embedding")) %>%
    map(colMeans, na.rm = TRUE) %>%
    reduce(rbind)

  rownames(text_emb) <- NULL

  return(text_emb)
}
