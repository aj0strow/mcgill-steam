require 'dm-sweatshop'

include DataMapper::Sweatshop::Unique

Prediction.fix{{
  predicted_for: DateTime.now,
  steam: 5600
}}

PastRecord.fix{{
  recorded_at: unique(:datetime){ |n| DateTime.parse("2013-07-03T23:00:0#{n}-04:00") },
  temperature: 21,
  wind_speed: 7,
  radiation: 379,
  humidity: 0.83,
  steam: 4800
}}