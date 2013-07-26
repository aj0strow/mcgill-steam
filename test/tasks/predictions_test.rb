require 'test_helper'

class PredictionsTest < Test
  
  setup do
    @past_record_attributes = {
      recorded_at: DateTime.parse('2012-10-19T01:00Z'), 
      temperature: 13.8, 
      radiation: -39, 
      humidity: 0.61, 
      wind_speed: 3.611111111, 
      steam: 9300
    }
  end
  
  test 'normalize past_record for csv' do
    @past_record = PastRecord.create(@past_record_attributes)
    expected = [ '10/19/2012 1:00', '2', 13.8, -39, 0.61, 3.611111111, 9300 ]
    normalized = Predictions.send(:normalize, @past_record)
    assert_equal expected, normalized
  end
  
  test 'complete past records are those with steam' do
    PastRecord.all.destroy
    PastRecord.create(@past_record_attributes)
    @past_record_attributes[:recorded_at] = DateTime.parse('2012-10-20T01:00Z')
    @past_record_attributes[:steam] = nil
    PastRecord.create(@past_record_attributes)
    complete_records = Predictions.send(:complete_past_records)
    assert_equal complete_records.count, 1
  end

  test 'generate CSV' do
    PastRecord.all.destroy
    records = [
      [ DateTime.parse('2012-10-19T01:00Z'), 13.8, -39, 0.61, 3.611111111, 9300 ],
      [ DateTime.parse('2012-10-19T02:00Z'), 12.5, -41, 0.59, 3.611111111, 9300 ],
      [ DateTime.parse('2012-10-19T03:00Z'), 11.9, -42, 0.64, 3.611111111, 8400 ]
    ]
    keys = %w(recorded_at temperature radiation humidity wind_speed steam)
    records.each do |record|
      PastRecord.create(keys.zip(record))
    end
    expected = [
      'Date,Hour,Temp,Radiation,Humidity,WindSpeed,Steam',
      '10/19/2012 1:00,2,13.8,-39,0.61,3.611111111,9300',
      '10/19/2012 2:00,3,12.5,-41,0.59,3.611111111,9300',
      '10/19/2012 3:00,4,11.9,-42,0.64,3.611111111,8400', ''
    ].join("\n")
    csv = Predictions.send(:generate_training_csv)
    assert_equal expected, csv
  end
  
  
  
end