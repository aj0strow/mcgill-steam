require 'httparty'
require 'time'

=begin

  Data points as follows:
  
  66077 (temperature) -> Monteal Temperature - CWTA
  66096 (windSpeed)   -> Montreal Windspeed - CWTA
  66094 (radiation)   -> Montreal Radiation - CWTA
  66095 (humidity)    -> Montreal Relative Humidity - CWTA
  45924               -> Downtown Campus - Steam Mass Flow

=end

module Pulse
  
  POINTS = {
    temperature: 66077,
    wind_speed: 66096,
    radiation: 66094,
    humidity: 66095,
    steam: 45924
  }
  
  class Base
    include HTTParty
    
    class << self
      
      def url(point)
        "https://api.pulseenergy.com/pulse/1/points/#{point}/data.json"
      end
      
      def query(time)
        { interval: 'day', start: time.utc.iso8601, key: ENV['PULSE_KEY'] }
      end
      
      def fetch(time, resource)
        point = POINTS[resource]        
        resp = get url(point), query: query(time)
        p resp.parsed_response
      end

      def fetch_points(time)
        fetch time, :temperature
        # fetch time, :wind_speed
        # fetch time, :radiation
        # fetch time, :humidity
        # fetch time, :steam
      end

    end
  end
  
  def self.fetch_points(time)
    Base.fetch_points(time)
  end
  
end


