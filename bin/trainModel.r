# Train the SVM model for a steam forecast
# For command line use with Rscript
# Usage: Rscript Train_Model.R training_set where_to_save_model
# **use absolute diectories

# Important to load these libraries for SVM
library(e1071)
library(rpart)

cat("Training SVM model... ")

# Grab all command line args
allArgs = commandArgs(trailingOnly = TRUE) # [1]training_set, [2]where_to_save_model, [3] Num_of_historic_hours_considered

# Uncomment for debugging
# allArgs = c("sampleTrainingSet.csv", "svmModel.RData", 3)

# Import training set
temp <-read.csv(allArgs[1]) 
trainingSet <- temp[-1] # Drop the date
# Import weather forecast
L <- length(trainingSet[[1]]) # The total number of rows

# Check the number of historic hours to be considered in the model
N <-as.numeric(allArgs[3])
numHistHrsCon <- N # For checking by predict.R later

# Make time lagged variables (i.e. to train on a "trend" in temperature)
posOfTemp <- 2; #Need to keep track of this
posOfHumd <- 4;

# First do Temperature
historicTemp <- trainingSet[[posOfTemp]] # First save the columns of data as they stand.
insertAfter <- posOfTemp # Keep track of where to put the time delayed column.

for (i in 1:N) {
  historicTemp <- c(NA, historicTemp)[1:L] #Append an NA before first entry, then clip the end
  trainingSet <- data.frame(trainingSet[1:insertAfter], historicTemp, trainingSet[-(1:insertAfter)])
  insertAfter <- insertAfter + 1;
}

# Now do humidity
posOfHumd <- posOfHumd + N # Keep in mind everything is wider by N now.
historicHumd <- trainingSet[[posOfHumd]] 
insertAfter <- posOfHumd # Keep track of where to put the time delayed column.

for (i in 1:N) {
  historicHumd <- c(NA, historicHumd)[1:L] #Append an NA before first entry, then clip the end
  trainingSet <- data.frame(trainingSet[1:insertAfter], historicHumd, trainingSet[-(1:insertAfter)])
  insertAfter <- insertAfter + 1;
}
 
# Cut off begining
trainingSet <- trainingSet[-(1:N),]

# Use to fine tune parameters - loooong run-times
# Tuner <- tune.svm(Steam ~ ., data = trainning.set, gamma = 10^(-3:1), cost = 10^(0:3))

# Train the model
svmModel <- svm(Steam ~ .,data = trainingSet, cost = 100, gamma = 0.1) # "cost" and "gamma" from Tuner

# Save the model for later use
save(svmModel, numHistHrsCon, file = allArgs[2])
cat("complete!\n")


