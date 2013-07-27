module Predictions
  class InvalidPredictionError < ArgumentError; end
  
  class << self
    
    def generate_training_csv
      CSV.generate do |csv|
        csv << %w(Date Hour Temp Radiation Humidity WindSpeed Steam)
        complete_past_records.each do |record|
          csv << normalize(record, true)
        end
      end
    end
    
    def generate_weather_forecast_csv(n_hours)
      CSV.generate do |csv|
        csv << %w(Date Hour Temp Radiation Humidity WindSpeed)
        recent_past_records(n_hours).each do |record|
          csv << normalize(record, false)
        end
      end
    end
    
    def save_predictions(csv)
      rows = CSV.parse(csv, headers: true, return_headers: false)
      predictions = rows.map do |row|
        date_time = DateTime.parse(row['Date'])
        steam_amount = row['SteamForecast'].to_f
        Prediction.new(predicted_for: date_time, steam: steam_amount)
      end
      raise(InvalidPredictionError, csv) unless predictions.all?(&:valid?)
      predictions.each(&:save)
    end
    
    def predict_steam_csv(svm_model, weather_forecast_csv)
      `Rscript predict.r "$PWD/svmModel.RData" "$PWD/sampleWeatherForecast.csv" "$PWD/predictions.csv" "3"`
    end
    
    
    private
    
    def recent_past_records(n_hours)
      PastRecord.all(limit: n_hours, order: [ :recorded_at.desc ]).to_a.reverse
    end
    
    def complete_past_records
      PastRecord.all(:steam.not => nil)
    end
    
    def normalize(past_record, include_steam = true)
      recorded_at = past_record.recorded_at
      date_time = recorded_at.strftime('%m/%d/%Y ') + recorded_at.strftime('%k:%M').strip
      hour = recorded_at.strftime('%k').strip.next
      normalized = [ 
        date_time, 
        hour,
        past_record.temperature,
        past_record.radiation.floor,
        past_record.humidity,
        past_record.wind_speed
      ]
      normalized << past_record.steam.floor if include_steam
      normalized
    end
    
  end
end