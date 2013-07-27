require 'data_mapper'

# all properties required
DataMapper::Property.required(true)

class Prediction
  include DataMapper::Resource
  
  property :id, Serial, key: true
  property :predicted_for, DateTime, index: true
  property :steam, Float
  
  # auto-updated, READ ONLY!
  property :updated_at, DateTime, required: false
  
  def self.for(date_time)
    # the sql order cannot be trusted with nanosecond differences
    # so we need to sort too
    
    matches = all(predicted_for: date_time, order: [ :updated_at.asc ])
    matches.sort_by(&:updated_at).last
  end
end

class PastRecord
  include DataMapper::Resource
  
  property :id, Serial, key: true
  property :recorded_at, DateTime, unique: true, unique_index: true
  property :temperature, Float
  property :wind_speed, Float
  property :radiation, Float
  property :humidity, Float
  property :steam, Float, required: false
end

DataMapper.finalize