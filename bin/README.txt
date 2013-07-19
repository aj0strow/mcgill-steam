Hi AJ,

I found some time and put together the R scripts. Try it out!

1) Install R: 
Easy on windows, for Ubuntu follow the below link
http://craig-russell.co.uk/2012/05/08/install-r-on-ubuntu.html#.Uds22uGPmXo

2) Install required packages: 
In the comand line type R. It should start the command-line interface, then
> install.packages('e1071')
Note you may have to run R as sudo if using Ubuntu.
You may also need to do
> install.packages('rpart')

3) Unzip the folder I gave you, and open a terminal in the folder's directory

4) Note the format of the existing csv files. I can tweak them to parse the date
in my script if you'd prefer (i.e. get hour of the day from the date). Just let 
me know.

5) Run the shell script.

6) Note the two new files that appear (predictions.csv, svmModel.RData) 

7) Call me with questions.

*** 

Note A) trainModel.R has a pretty long runtime, but will only need to be 
run once a week or so. Most hours we will just need predict.R

Note B) sampleWeatherForecast.csv actually has 27 entries... that is because the
svm model is design to use a weather "trend" i.e. predict based on a moving 
window. So the first 3 lines of data should be old data from records, while the 
next 24 lines should be the most recent weather forecast from Pulse.

Note C) This might get you started running R on Heroku
https://github.com/virtualstaticvoid/heroku-buildpack-r




