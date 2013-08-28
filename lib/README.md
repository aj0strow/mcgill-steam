# Lib

The application library is made up of logically distinct modules. See the readme in `/lib/tasks` for documentation on rake tasks available. 

### Models

We use [DataMapper](http://datamapper.org/) as the ORM on top of the Postgres database. It interfaces with the database and generates SQL, so the program can deal with nice ruby objects. DataMapper works by enhancing normal ruby objects, and provides a DSL.

The two objects, `Prediction` and `PastRecord` represent tables in the Postgres database. Each property of the object represents a column. The columns should be self-explanatory from the code with some knowledge of relational databases. 

### Predictions

The `Predictions` module is the underlying implementation of the predictions rake tasks. It does everything short of actually reading and writing from files. It calls the R scripts directly through native system calls. 

### Pulse

The `Pulse` module defines the resources, assigns the Pulse API point and a unique API key to each resource, and allows fetching all 5 resources for a 24 hour block in a single call to `Pulse.fetch(datetime)`. It returns a nested hash, which in JSON would look like the fields for a PastRecord: 

```
{ datetime: { recorded_at: datetime, temperature: ###, wind_speed: ###, ... } }
```

-----

AJ Ostrow, August, 2013