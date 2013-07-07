require 'httparty'
require 'time'
require 'async_enum'

module Pulse
  
  RESOURCES = [ :temperature, :wind_speed, :radiation, :humidity, :steam ]
  
  POINTS = Hash[ RESOURCES.zip([ 66077, 66096, 66094, 66095, 45924 ]) ]

  KEYS = Hash[ RESOURCES.zip(ENV['PULSE_KEYS'].split('|')) ]
  
  class Base
    include HTTParty
    
    class << self
      
      def url(point)
        "https://api.pulseenergy.com/pulse/1/points/#{point}/data.json"
      end
      
      def query(time, resource)
        key = KEYS[resource]
        { interval: 'day', start: time.utc.iso8601, key: key }
      end
      
      def fetch(time, resource)
        point = POINTS[resource]        
        resp = get url(point), query: query(time, resource)
        p resp.parsed_response
      end

      def fetch_points(datetime)
        time = datetime.to_time
        resources = RESOURCES
        data = resources.async.map do |resource|
          Pulse::Base.fetch time, resource
        end
        data
      end

    end
  end
  
  def self.fetch_points(time)
    Base.fetch_points(time)
  end
  
end


