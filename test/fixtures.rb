require 'dm-sweatshop'

Prediction.fix{{
  predicted_at: DateTime.now,
  steam: 5600
}}

PastRecord.fix{{
  recorded_at: DateTime.parse('2013-07-03T23:00:00-04:00'),
  temperature: 21,
  wind_speed: 7,
  radiation: 379,
  humidity: 0.83,
  steam: 4800
}}