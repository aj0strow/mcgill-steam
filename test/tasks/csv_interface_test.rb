require 'test_helper'

class CSVInterfaceTest < Test
  setup do
    @past_record_attributes = {
      recorded_at: DateTime.parse('2012-10-19T01:00-04:00'), 
      temperature: 13.8, 
      radiation: -39, 
      humidity: 0.61, 
      wind_speed: 3.611111111, 
      steam: 9300
    }
    PastRecord.all.destroy
  end
  
  test 'normalize past_record for csv' do
    @past_record = PastRecord.create(@past_record_attributes)
    expected = [ '2012-10-19T01:00:00-04:00', '2', 13.8, -39, 0.61, 3.611111111, 9300 ]
    normalized = Predictions.send(:normalize, @past_record)
    assert_equal expected, normalized
  end
  
  test 'complete past records are those with steam' do
    PastRecord.create(@past_record_attributes)
    @past_record_attributes[:recorded_at] = DateTime.parse('2012-10-20T01:00-04:00')
    @past_record_attributes[:steam] = nil
    PastRecord.create(@past_record_attributes)
    complete_records = Predictions.send(:complete_past_records)
    assert_equal complete_records.count, 1
  end

  test 'generate training CSV' do
    records = [
      [ DateTime.parse('2012-10-19T01:00-04:00'), 13.8, -39, 0.61, 3.611111111, 9300 ],
      [ DateTime.parse('2012-10-19T02:00-04:00'), 12.5, -41, 0.59, 3.611111111, 9300 ],
      [ DateTime.parse('2012-10-19T03:00-04:00'), 11.9, -42, 0.64, 3.611111111, 8400 ]
    ]
    keys = %w(recorded_at temperature radiation humidity wind_speed steam)
    records.each do |record|
      PastRecord.create(keys.zip(record))
    end
    expected = [
      'Date,Hour,Temp,Radiation,Humidity,WindSpeed,Steam',
      '2012-10-19T01:00:00-04:00,2,13.8,-39.0,0.61,3.611111111,9300.0',
      '2012-10-19T02:00:00-04:00,3,12.5,-41.0,0.59,3.611111111,9300.0',
      '2012-10-19T03:00:00-04:00,4,11.9,-42.0,0.64,3.611111111,8400.0', ''
    ].join("\n")
    csv = Predictions.send(:generate_training_csv)
    assert_equal expected, csv
  end
  
  test 'recent past records' do
    PastRecord.all.destroy
    ('2012-10-19T01:00'..'2012-10-19T01:30').each do |date_time|
      @past_record_attributes[:recorded_at] = DateTime.parse(date_time + '-04:00')
      PastRecord.create(@past_record_attributes)
    end
    past_records = Predictions.send(:recent_past_records, 27)
    assert_equal 27, past_records.count
    assert_equal DateTime.parse('2012-10-19T01:30-04:00'), past_records.last.recorded_at
  end
  
  test 'generate weather forecast CSV' do
    records = [
      [ DateTime.parse('2012-10-19T01:00-04:00'), 13.8, -39, 0.61, 3.611111111 ],
      [ DateTime.parse('2012-10-19T02:00-04:00'), 12.5, -41, 0.59, 3.611111111 ],
      [ DateTime.parse('2012-10-19T03:00-04:00'), 11.9, -42, 0.64, 3.611111111 ]
    ]
    keys = %w(recorded_at temperature radiation humidity wind_speed)
    records.each do |record|
      PastRecord.create(keys.zip(record))
    end
    expected = [
      'Date,Hour,Temp,Radiation,Humidity,WindSpeed',
      '2012-10-19T01:00:00-04:00,2,13.8,-39.0,0.61,3.611111111',
      '2012-10-19T02:00:00-04:00,3,12.5,-41.0,0.59,3.611111111',
      '2012-10-19T03:00:00-04:00,4,11.9,-42.0,0.64,3.611111111', ''
    ].join("\n")
    csv = Predictions.send(:generate_weather_forecast_csv, 27)
    assert_equal expected, csv
  end
  
  test 'save predictions from CSV' do
    Prediction.all.destroy
    predictions_csv = [
      '"Date","SteamForecast"',
      '"2013-02-27T00:00:00-04:00","32977.107362766"',
      '"2013-02-27T01:00:00-04:00","32778.3239391544"',
      '"2013-02-27T02:00:00-04:00","35496.1768815789"'
    ].join("\n")
    Predictions.save_predictions(predictions_csv)
    assert_equal 3, Prediction.count
    assert_equal 32977.107362766, Prediction.first.steam    
  end
end