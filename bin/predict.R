# Predict with an SVM model for a steam forecast
# For command line use with Rscript
# Usage: Rscript Train_Model.R training_set_absolute_dir where_to_save_model_absolute_dir

# Important to load these libraries for SVM
library(e1071)
library(rpart)

# Grab all command line args
allArgs = commandArgs(trailingOnly = TRUE) # [1]svm_model, [2]weather_forecast, [3]where_to_save_predictions

# For testing - should be commented when run from command line
# setwd("/home/marc/Dropbox/Work/Work at FOD/Data Analysis/R for Webapp")
# allArgs = c("svmModel.RData", "sampleWeatherForecast.csv", "predictions.csv")

# Load SVM model 
load(allArgs[1])

# Import weather forecast - assumes an include 3 "historic values"
rawWeather <-read.csv(allArgs[2]) 
weatherForecast <- rawWeather[2:7] # Drop the date

# Make time lagged variables (i.e. training on a "trend" in temperature)
Temp1 <- c(NA, weatherForecast[[2]])[1:length(weatherForecast[[2]])]
Temp2 <- c(NA, NA, weatherForecast[[2]])[1:length(weatherForecast[[2]])]
Temp3 <- c(NA, NA, NA, weatherForecast[[2]])[1:length(weatherForecast[[2]])]
toInsert<- cbind(Temp1,Temp2,Temp3)

# Insert time delayed variables and cut off first 3 hours
weatherForecast <- data.frame(weatherForecast[,1:2],toInsert,weatherForecast[,3:6])
weatherForecast <- weatherForecast[4:nrow(weatherForecast),]

# Make predictions
SteamForecast <- as.vector(predict(svmModel, weatherForecast[,-ncol(weatherForecast)])) #Note the removal of the final col

# Combine with dates and save output as CSV
Date <- as.vector(rawWeather[[1]])[-(1:3)]
write.csv(cbind(Date, SteamForecast), file = allArgs[3], row.names = FALSE)
