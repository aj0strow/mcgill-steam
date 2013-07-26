module Predictions
  class << self
    
    def generate_training_csv
      CSV.generate do |csv|
        csv << %w(Date Hour Temp Radiation Humidity WindSpeed Steam)
        normalized_past_records.each do |record|
          csv << record
        end
      end
    end
    
    
    private
    
    
    def normalized_past_records
      complete_past_records.map do |past_record|
        normalize(past_record)
      end
    end
    
    def complete_past_records
      PastRecord.all(:steam.not => nil)
    end
    
    def normalize(past_record)
      recorded_at = past_record.recorded_at
      date_time = recorded_at.strftime('%m/%d/%Y ') + recorded_at.strftime('%k:%M').strip
      hour = recorded_at.strftime('%k').strip.next
      normalized = [ 
        date_time, 
        hour,
        past_record.temperature,
        past_record.radiation.floor,
        past_record.humidity,
        past_record.wind_speed,
        past_record.steam.floor 
      ]
      normalized
    end
    
  end
end