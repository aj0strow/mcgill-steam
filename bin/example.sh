# This shows an example of how to use the R scripts.

Rscript trainModel.r "$PWD/sampleTrainingSet.csv" "$PWD/svmModel.RData" "3"

Rscript predict.r "$PWD/svmModel.RData" "$PWD/sampleWeatherForecast.csv" "$PWD/predictions.csv" "3"