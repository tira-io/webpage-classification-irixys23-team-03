FROM r-base:latest

RUN Rscript dependencies.R

WORKDIR /app
COPY . /app

RUN R -e "install.packages(c('dplyr', 'jsonlite'), repos='http://cran.rstudio.com/')"

ENTRYPOINT [ "Rscript", "/app/predict.R", "$inputDataset/inputs.jsonl", "$outputDir/predictions.jsonl", "/app/model.RData" ]
