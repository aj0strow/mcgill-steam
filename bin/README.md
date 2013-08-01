# R Predictions

All of the scripts and data in `/bin` are for generating the SVM model, training it, and then generating predictions. The model and R runtime interfaces with the ruby app through temporary CSV files. 

### Installation

For ubuntu, see this link: http://craig-russell.co.uk/2012/05/08/install-r-on-ubuntu.html#.Uds22uGPmXo.

For OSX, install R using homebrew. R depends on fortran, and gfortran is a good one. 

```
$ brew update
$ brew install gfortran
$ brew install R
```

Installing pachages is done in the R console, or in the `init.r` script:

```R
install.packages('e1071')
install.packages('rpart')
```

### Working with R

To start the interactive console, simply use the `R` command, exit with `q()`:

```
$ R
>> q()
```

To train the model, the arguments are the training set, the svm model, and the amount of past records:

```
$ Rscript trainModel.r "$PWD/trainingSet.csv" "$PWD/svmModel.RData" 3
```

To generate predictions, the arguments are the svm model location, the forecasts, where to save the prdictions, and the amount of past records. 

```
$ Rscript predict.r "$PWD/svmModel.RData" "$PWD/sampleWeatherForecast.csv" "$PWD/predictions.csv" 3
```

### Notes

The `trainModel.r` has a pretty long runtime, but should only be ran once a week or so. Each hour, only `predict.r` should be used.

The number `3` for the number of past records corresponds to how many records beyond the 24-hour mark are included to start the trends for the predictions. They are old records with real steam values. 

For using R on Heroku, refer to https://github.com/virtualstaticvoid/heroku-buildpack-r
