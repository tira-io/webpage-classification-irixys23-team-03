FROM r-base:latest

WORKDIR /app
COPY . /app

RUN R -e "install.packages(c('dplyr', 'randomForestSRC', 'purrr', 'word2vec', 'jsonlite'), repos='http://cran.rstudio.com/')"

ENTRYPOINT [ "Rscript", "/app/predict.R", "$inputDataset/inputs.jsonl", "$outputDir/predictions.jsonl", "/app/model.RData" ]
