# Rake Tasks

All of the tasks in `/lib/tasks` are accessed through the [rake](http://rake.rubyforge.org/) aka *ruby make* command. They can be scheduled using the Heroku Scheduler plugin (https://addons.heroku.com/scheduler). The rake file names correspond to the task namespace.

### DB

The database tasks are only to be used on your machine (locally). Make sure to start the Postgres database on your machine before using the tasks or they will fail. 

```
$ rake db:create
```

Creates the Postgres database for use in the current `RACK_ENV` (an environment variable). To create the test database, set the environment for the command:

```
$ RACK_ENV=test rake db:create
```

```
$ rake db:drop
```

Drops the Postgres database. Use this if the database has become corrupted, or to start clean. 

### Predictions

The predictions tasks are used to automate everything to do with generating steam predictions. It is basically a task interface to work with the `Predictions` ruby module located in `/lib/predictions.rb`.

```
$ rake predictions:training_csv
```

Generates the training CSV and saves it to `/bin/csv/training.csv`. Example CSV first 2 lines:

```csv
Date,Hour,Temp,Radiation,Humidity,WindSpeed,Steam
2013-07-31T17:00:00-04:00,18,26.0,455.0,0.5,9.0,6000.0
```

```
$ rake predictions:train_model
```

Trains the R prediction model using the `/bin/trainModel.r` script. It depends on the `predictions:training_csv` task which it automatically runs first. 

```
$ rake predictions:forecast_csv
$ rake predictions:forecast_csv[#]
```

Writes # amount of weather forecast lines (PastRecord fields without the steam column), and writes it to `/bin/csv/forecast.csv`. The amount of data records defaults to 27. 

```
$ rake predictions:save
```

Saves the predictions from raw CSV in `/bin/csv/predictions.csv` to action Prediction records in the database.

```
$ rake predictions:steam
$ rake predictions:steam[#]
```

Generates steam predictions using `/bin/predict.r` for the last # of hours (default 24). It writes the predictions as CSV to `/bin/csv/predictions.csv`. 

```
$ rake predictions:generate
```

Counts the number of PastRecords without a real steam value, generates predictions for those points in time with `predictions:steam`, and saves them to the database with `predictions:save`.

### Pulse

The pulse tasks are for interfacing with the Pulse API. It is a task wrapper for working with the `Pulse` ruby module located in `/lib/pulse.rb`. 

```
$ rake pulse:fetch
$ rake pulse:fetch[iso8601-datetime]
```

Rounds the provided iso datetime (default current time) to the nearest hour. Then it fetches 48 hours worth of hourly pulse data; 24 hours before and 24 hours after. It then overwrites the PastRecords for each of those `recorded_at` time points with the latest values. 

A full 48 hour window was necessary, as the real steam values lagged a bit behind reality. 

-----

AJ Ostrow, August, 2013