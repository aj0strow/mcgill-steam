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

See the environment variables section below, add the file, and then run:

```
$ rackup -p 1234
```

View the website at http://localhost:1234/.

### Environment Variables

Not included in the version control is a file `config/environment_variables.rb` with the API keys, included as follows:

```ruby
# config/environment_variables.rb

# 5 pipe-delimited API keys
ENV['PULSE_KEYS'] = '*********|********|********|********|********'
```

It will be set on the production machine as a real environment variable. 

### Rake Tasks
```
$ rake pulse:fetch
$ rake pulse:fetch[2013-07-03T03:00:00]

Fetch pulse data for the date specified (default is yesterday) and create 24 PastRecords for each hour.

### Useful Links

Pulse energy API documentation: http://developer.pulseenergy.com/ (100 req/hr limit)

### Database

If it were CSV, it would be like the following:

| datetime | weekday (0-6) | hour\_of\_day | temperature | wind\_speed | radiation | humidity | steam | fc0 | fc3 | fc11 | fc23 |
| -------- |-------------- | ------------- | ----------- | ----------- | --------- | -------- | ----- | --- | --- | ---- | -----|
| "2013-06-14T19:00:00Z" | 5 | 19 | 22.0 | 1.0 | 187.0 | 0.7145 | 15640.4 | NA | 16060.0 | 18040.4 | 15040.4 |
| ** "2013-06-14T18:00:00Z" | 5 | 18 | 24.5 | 3.8 | 200.4 | 0.7890 | 15040.4 | 15040.4 | 18060.0 | 18040.4 | 15740.0 |
| "2013-06-14T17:00:00Z" | 5 | 17 | 25.5 | 5.7 | 250.6 | 0.6756 | 15786.0 | 15040.4 | 16400.4 | 18060.0 | 18040.4 |

The idea is that the 2nd line (**) is the current hour. It _and everything after it_ is a forecast, while everything before is history. Note that `fcX` is what the steam was predicted to be X hours before it got to position **. We want to store this to keep track of how good the forecasts are.
 
### Product

- A graph showing forecasts for the next day (week? year?) with confidence intervals.
- manually modify database
- retrain the function at will

### Calculating Steam

Steam is calculated as a function: `steam = f(weekday, hour_of_day, temperature, wind_speed, radiation, humidity)`

... marc? ...

### Calculating Confidence

Confidence is determined as follows:

... marc? ...
