require 'test_helper'

class PulseTest < Test
  
  test 'resources correct' do
    resources = [ :temperature, :wind_speed, :radiation, :humidity, :steam ].sort
    assert_equal resources, Pulse::RESOURCES.sort
  end
  
  test 'Base url' do
    url = Pulse::Base.url(:radiation)
    assert_equal "https://api.pulseenergy.com/pulse/1/points/66094/data.json", url
  end
  
  test 'Base query has utc' do
    datetime = DateTime.parse('2013-07-07 01:07:06')
    q = Pulse::Base.query(datetime.to_time, :steam)
    assert_equal '2013-07-07T01:07:06Z', q[:start]
  end
  
  test 'Base sanitize' do
    sanitized = Pulse::Base.sanitize(:steam, pulse_sample_response)
    
    assert_equal :steam, sanitized[:resource]
    assert_equal 24, sanitized[:data].size
    assert sanitized[:average].is_a?(Float)
    assert sanitized[:start]
    assert sanitized[:end]
  end
  
  test 'Base compile_data' do
    compiled = Pulse::Base.compile_data(pulse_sample_sanitized_responses)
    assert_equal 24, compiled.size
    
    expected_keys = [ :recorded_at ].concat(Pulse::RESOURCES).sort
    compiled.values.each do |attrs|
      assert_equal expected_keys, attrs.keys.sort
    end
  end 
  
end