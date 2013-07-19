# Train the SVM model for a steam forecast
# For command line use with Rscript
# Usage: Rscript Train_Model.R training_set where_to_save_model
# **use absolute diectories

# Important to load these libraries for SVM
library(e1071)
library(rpart)

# Grab all command line args
allArgs = commandArgs(trailingOnly = TRUE) # [1]training_set, [2]where_to_save_model

# Import training set
temp <-read.csv(allArgs[1]) 
trainingSet <- temp[2:7] # Drop the date

# Make time lagged variables (i.e. training on a "trend" in temperature)
Temp1 <- c(NA, trainingSet[[2]])[1:length(trainingSet[[2]])]
Temp2 <- c(NA, NA, trainingSet[[2]])[1:length(trainingSet[[2]])]
Temp3 <- c(NA, NA, NA, trainingSet[[2]])[1:length(trainingSet[[2]])]
toInsert<- cbind(Temp1,Temp2,Temp3)

# Insert time delayed variables and cut off first 3 hours
trainingSet <- data.frame(trainingSet[,1:2],toInsert,trainingSet[,3:6])
trainingSet <- trainingSet[4:nrow(trainingSet),]

# Use to fine tune parameters - loooong run-times
# Tuner <- tune.svm(Steam ~ ., data = trainning.set, gamma = 10^(-3:1), cost = 10^(0:3))

# Train the model
svmModel <- svm(Steam ~ .,data = trainingSet, cost = 100, gamma = 0.1) # "cost" and "gamma" from Tuner

# Save the model for later use
save(svmModel, file = allArgs[2])

