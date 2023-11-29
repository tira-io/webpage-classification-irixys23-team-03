rm(list = ls())

library(word2vec)
library(dplyr)

source("utils.R")

# PARAMS -----------------------------------------------------------------------
text_file <- "data/train/D1_train.jsonl"
labels_file <- "data/train/D1_train-truth.jsonl"

vec_dim <- 5000
window <- 5
iterations <- 200
threads <- 4
min_count <- 10

tune_bayes_samples_number <- 20
tune_bayes_iterations_number <- 20
tune_folds_number <- 5
trees_number <- list(min = 250, max = 1000)

# TEST PARAMS ------------------------------------------------------------------
# text_file <- "../data/test/text.jsonl"
# labels_file <- "../data/test/labels.jsonl"

# vec_dim <- 50
# window <- 5
# iterations <- 20
# threads <- 1
# min_count <- 5

# tune_bayes_samples_number <- 2
# tune_bayes_iterations_number <- 2
# tune_folds_number <- 3
# trees_number <- list(min = 2, max = 10)

labels <- jsonlite::stream_in(file(labels_file, "r"))

data <- jsonlite::stream_in(file(text_file, "r")) %>%
  mutate(y = factor(labels$label), html = prepare_text(html))

# close connections
closeAllConnections()

# Train Word2Vec model
word_vec_model <- word2vec(
  data$html,
  type = "cbow", # or use "skip-gram"
  dim = vec_dim, # word vector dimension
  window = window, # window size
  iter = iterations, # number of iterations
  threads = threads, # number of threads, adjust as needed,
  min_count = min_count # minimum word count
)

X <- embed_text(data$html, word_vec_model, vec_dim)
y <- factor(data$y)

# Train a random forest model
tune_model <- SKM::random_forest(
  X, y,
  trees_number = trees_number,
  node_size = list(min = 2, max = 10),
  sampled_x_vars_number = list(min = 0.2, max = 0.6),

  tune_type = "Bayesian_optimization",
  tune_loss_function = "accuracy",
  tune_folds_number = tune_folds_number,
  tune_bayes_samples_number = tune_bayes_samples_number,
  tune_bayes_iterations_number = tune_bayes_iterations_number
)

tune_model$hyperparams_grid
rf_model <- tune_model$fitted_model

save(rf_model, word_vec_model, file = "model.RData")
