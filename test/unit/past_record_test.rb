require 'test_helper'

class PastRecordTest < Test
  
  setup do
    @record = PastRecord.gen
  end
  
  test 'recorded_at required' do
    @record.recorded_at = nil
    refute @record.save
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

  test 'steam required' do
    @record.steam = nil
    refute @record.save
  end
  
end