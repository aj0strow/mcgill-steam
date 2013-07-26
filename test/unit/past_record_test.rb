require 'test_helper'

class PastRecordTest < Test
  setup do
    @record = PastRecord.gen
  end
  
  test 'recorded_at required' do
    @record.recorded_at = nil
    refute @record.save
  end
  
  test 'recorded_at is unique' do
    date_time = DateTime.parse('2012-10-19T01:30Z')
    other = PastRecord.gen(recorded_at: date_time)
    @record.recorded_at = date_time
    refute @record.save    
  end
  
  test 'recorded_at matches' do
    date_time = DateTime.now
    @record.recorded_at = date_time
    @record.save
    assert_equal date_time.iso8601, @record.reload.recorded_at.iso8601
  end

  test 'temperature required' do
    @record.temperature = nil
    refute @record.save
  end

  test 'wind_speed required' do
    @record.wind_speed = nil
    refute @record.save
  end

  test 'radiation required' do
    @record.radiation = nil
    refute @record.save
  end

  test 'humidity required' do
    @record.humidity = nil
    refute @record.save
  end
end