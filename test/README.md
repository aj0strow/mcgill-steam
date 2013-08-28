# Testing

The test suite is written with ruby using the [Minitest](https://github.com/seattlerb/minitest) testing framework. To run the tests, simply use the test rake task:

```
$ rake test
```

### Breakdown

The test suite is broken into sections:

* Server

  `/test/server` is for the user-facing website

* Tasks

  `/test/tasks` is for the myriad background tasks that go into automating the fetching of Pulse data and generating predictions

* Unit

  `/test/unit` is for the database resource objects, so unit tests for PastRecord and Prediction. Fixtures are used to mock out the database objects for testing, using the [dm-sweatshop](https://github.com/datamapper/dm-sweatshop) extension to DataMapper. 
  
-----

AJ Ostrow, August, 2013

