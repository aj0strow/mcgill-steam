# McGill Steam

> McGill Energy Project   
> Alexander Ostrow, Marc-Etienne Brunet   
> Summer 2013   

http://mcgill-steam.herokuapp.com/

### Installing

Clone the repository:

```
$ cd ~/where/my/projects/are
$ git clone git@github.com:aj0strow/mcgill-steam.git
$ cd mcgill-steam
```

**See the Postgres and Environement Variables sections below.**

To start the server:

```
$ rackup -p 1234
```

View the website at http://localhost:1234/.

### Postgres

Make sure you have Postgres database installed and running. To start it:

```
$ pg_ctl -D /usr/local/var/postgres -l logfile start
```

If you havent added the admin pack, add it:

```
$ psql postgres -c 'CREATE EXTENSION "adminpack";'
```

And go into the database shell to add the user:

```
$ psql -d postgres
postgres=# create role mcgill_steam login createdb;
postgres=# \q
```

Finally, create the development database:

```
$ createdb -E UTF8 -w -O mcgill_steam mcgill_steam_development
```

See more about Postgres at the bottom of this: http://www.ajostrow.me/thoughts/installing-and-using-postgresql-on-osx-with-rails#nav

### Environment Variables

Not included in the version control is a file `config/environment_variables.rb` with the API keys, included as follows:

```ruby
# config/environment_variables.rb

# 5 pipe-delimited API keys
ENV['PULSE_KEYS'] = '*********|********|********|********|********'
```

It will be set on the production machine as a real environment variable. 

### Rake Tasks

For the scheduler:

```
$ rake hourly
$ rake weekly
```

Fetch pulse data for the date specified (default is now) and create or update 48 PastRecords for each hour.

```
$ rake pulse:fetch
$ rake pulse:fetch[2013-07-03T03:00:00]
```

Create and drop database:

```
$ rake db:create
$ rake db:drop
```

Train the SVM model:

```
$ rake predictions:train_model
```

To generate steam predictions:

```
$ rake predictions:generate
```

For more documentation, see `/lib/tasks/README.md`.

### Useful Links

Pulse energy API documentation: http://developer.pulseenergy.com/ (100 req/hr limit)

### Database

There are two models. `PastRecord` and `Prediction`. The idea is that there is a single PastRecord per hour on the hour, and many Predictions for each hour in the future, where the most recent can be grabbed from the `updated_at` field (automatically set, so it is read only.)

Predictions are theoretically useless once the hour has passed, but could be useful for training the machine learning algorithm. 

##### PastRecord

PastRecords should be queried by their `recorded_at` field, as that is the unique natural key. 

| id   | recorded\_at           | temperature | wind\_speed | radiation | humidity | steam   |
| ---: | ---------------------- | ----------: | ----------: | --------: | -------: | ------: |
|    1 | "2013-06-14T19:00:00Z" |        22.0 |         1.0 |     187.0 | 0.7145   | 15640.4 |
|    2 | "2013-06-14T18:00:00Z" |        24.5 |         3.8 |     200.4 | 0.7890   | 15040.7 |
|    3 | "2013-06-14T17:00:00Z" |        25.5 |         5.7 |     250.6 | 0.6756   | 15786.0 |

##### Prediction

The `predicted_for` need not be unique, but it is the natural key and is indexed. Just make sure to order_by `udated_at` when grabbing records, and limit to 1. 


| id   | predicted\_for         | steam   | updated\_at            |
| ---: | ---------------------- | ------: | ---------------------- |
|    1 | "2013-06-14T23:00:00Z" | 15652.4 | "2013-06-14T18:00:00Z" |
|    2 | "2013-06-14T22:00:00Z" | 16048.1 | "2013-06-14T18:00:00Z" |

### Product

- A graph showing forecasts for the next day (week? year?) with confidence intervals.
- manually modify database
- retrain the function at will

### Calculating Steam

Steam is forecasted using the libsvm package in R.

### Calculating Confidence

Confidence is determined as follows: - TBD
