=begin

  Data points as follows:
  
  66077 (temperature) -> Monteal Temperature - CWTA
  66096 (windSpeed)   -> Montreal Windspeed - CWTA
  66094 (radiation)   -> Montreal Radiation - CWTA
  66095 (humidity)    -> Montreal Relative Humidity - CWTA
  45924               -> Downtown Campus - Steam Mass Flow

=end

POINTS = {
  temperature: 66077,
  wind_speed: 66096,
  radiation: 66094,
  humidity: 66095,
  steam: 45924
}

def fetch(resource)
  puts "Data point for #{resource}: #{POINTS[resource]}"
end

def fetch_points
  fetch :temperature
  fetch :wind_speed
  fetch :radiation
  fetch :humidity
  fetch :steam
end