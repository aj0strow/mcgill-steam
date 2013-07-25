# Predict with an SVM model for a steam forecast
# For command line use with Rscript
# Usage: Rscript Train_Model.R training_set_absolute_dir where_to_save_model_absolute_dir

# Important to load these libraries for SVM
library(e1071)
library(rpart)

# Grab all command line args
#allArgs = commandArgs(trailingOnly = TRUE) # [1]svm_model, [2]weather_forecast, [3]where_to_save_predictions, [4]Num_of_historic_hours_considered 

# For testing - should be commented when run from command line
setwd("/home/marc/mcgill-steam/bin")
allArgs = c("svmModel.RData", "sampleWeatherForecast.csv", "predictions.csv","3")

# Load SVM model 
load(allArgs[1])

# Check number of historic hours considered is the same as model
N <- as.numeric(allArgs[4]) # The amount back in time to consider in the trend.
stopifnot(N == numHistHrsCon)

# Import weather forecast
rawWeather <-read.csv(allArgs[2]) 
weatherForecast <- rawWeather[-1] # Drop the date
L <- length(weatherForecast[[1]]) # The total number of rows

# Make time lagged variables (i.e. to train on a "trend" in temperature)
posOfTemp <- 2;
posOfHumd <- 4;

# First do Temperature
historicTemp <- weatherForecast[[posOfTemp]] # First save the columns of data as they stand.
insertAfter <- posOfTemp # Keep track of where to put the time delayed column.

for (i in 1:N) {
  historicTemp <- c(NA, historicTemp)[1:L] #Append an NA before first entry, then clip the end
  weatherForecast <- data.frame(weatherForecast[1:insertAfter], historicTemp, weatherForecast[-(1:insertAfter)])
  insertAfter <- insertAfter + 1;
}

# Now do humidity
posOfHumd <- posOfHumd + N # Keep in mind everything is wider by N now.
historicHumd <- weatherForecast[[posOfHumd]] 
insertAfter <- posOfHumd # Keep track of where to put the time delayed column.

for (i in 1:N) {
  historicHumd <- c(NA, historicHumd)[1:L] #Append an NA before first entry, then clip the end
  weatherForecast <- data.frame(weatherForecast[1:insertAfter], historicHumd, weatherForecast[-(1:insertAfter)])
  insertAfter <- insertAfter + 1;
}
 
# Cut of begining
weatherForecast <- weatherForecast[-(1:N),]

# Make predictions
SteamForecast <- as.vector(predict(svmModel, weatherForecast))

# Combine with dates and save output as CSV
Date <- as.vector(rawWeather[[1]])[-(1:3)]
write.csv(cbind(Date, SteamForecast), file = allArgs[3], row.names = FALSE)
