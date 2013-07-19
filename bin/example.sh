#This shows an example of how to use the R scripts.

Rscript trainModel.R "$PWD/sampleTrainingSet.csv" "$PWD/svmModel.RData"

Rscript predict.R "$PWD/svmModel.RData" "$PWD/sampleWeatherForecast.csv" "$PWD/predictions.csv"
