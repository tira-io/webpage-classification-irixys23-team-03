library(dplyr)

params <- commandArgs(trailingOnly = TRUE)

input_file <- params[1]
output_file <- params[2]
model_file <- params[3]

classes <- c("Malicious", "Benign", "Adult")

data <- jsonlite::stream_in(file(input_file, "r")) %>%
  select(uid) %>%
  mutate(label = sample(classes, n(), replace = TRUE))

con_out <- file(output_file, open = "wb")
jsonlite::stream_out(data, con_out, append = FALSE, pagesize = 1000)
