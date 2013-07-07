require 'data_mapper'

# all properties required
DataMapper::Property.required(true)

class Prediction
  include DataMapper::Resource
  
  property :id, Serial, key: true
  property :predicted_at, DateTime
  property :steam, Float
  
  # auto-updated, READ ONLY!
  property :updated_at, DateTime, required: false
end

class PastRecord
  include DataMapper::Resource
  
  property :id, Serial, key: true
  property :recorded_at, DateTime, index: true
  property :temperature, Float
  property :wind_speed, Float
  property :radiation, Float
  property :humidity, Float
  property :steam, Float
end

DataMapper.finalize