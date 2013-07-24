require 'httparty'
require 'time'
require 'async_enum'

module Pulse
  
  RESOURCES = [ :temperature, :wind_speed, :radiation, :humidity, :steam ].freeze
  POINTS = Hash[ RESOURCES.zip([ 66077, 66096, 66094, 66095, 45924 ]) ].freeze
  KEYS = Hash[ RESOURCES.zip(ENV['PULSE_KEYS'].split('|')) ].freeze
  
  class Base
    include HTTParty
    
    class << self
      
      def url(resource)
        point = POINTS[resource]
        "https://api.pulseenergy.com/pulse/1/points/#{point}/data.json"
      end
      
      def query(time, resource)
        key = KEYS[resource]
        { interval: 'day', start: time.utc.iso8601, key: key }
      end
      
      def fetch(time, resource)
        resp = get url(resource), query: query(time, resource)
        sanitize(resource, resp.parsed_response)
      end
      
      def sanitize(resource, json)
        quantities = json['data'].select do |timestamp, _| 
          timestamp =~ /T\d\d:00:00/
        end
        hash = {
          resource: resource,
          start: json['start'],
          end: json['end'],
          data: quantities
        }
        hash[:average] = json['average'].to_f if json['average']
        hash
      end

      def fetch_resources(time)
        time = to_nearest_hour(time)
        pulse_responses = RESOURCES.async.map do |resource|
          Pulse::Base.fetch(time, resource)
        end
        compile_data(pulse_responses)
      end
      
      def to_nearest_hour(time)
        hour = 60 * 60
        Time.at((time.to_f / hour).floor * hour)
      end
      
      def compile_data(pulse_responses)
        records = Hash.new do |hash, key|
          datetime = DateTime.parse(key)
          hash[key] = { recorded_at: datetime }
        end
        pulse_responses.each do |response|
          resource = response[:resource]
          response[:data].each do |datetime, amount|
            records[datetime][resource] = amount
          end
        end
        records
      end

    end
  end
  
  def self.fetch_records(datetime)
    time = datetime.to_time
    Base.fetch_resources(time).values
  end
  
end


