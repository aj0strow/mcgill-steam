require 'test_helper'
require 'multi_json'

class AppTest < Test
  
  test 'GET /' do
    get '/'
    assert last_response.successful?
  end
  
  test 'GET /records.json with days' do
    PastRecord.all.destroy
    records = 5.times.map{ PastRecord.gen }
    
    get '/records.json', days: 10
    assert last_response.successful?
    
    json = MultiJson.load(last_response.body)
    assert_equal 5, json.count
    assert_equal records.last.steam, json.first['steam']
  end
  
  test 'GET /records.json without days' do
    PastRecord.all.destroy
    5.times{ PastRecord.gen }
    
    get '/records.json'
    
    json = MultiJson.load(last_response.body)
    assert_equal 5, json.count
  end
  
  test 'GET /records.json with predictions' do
    PastRecord.all.destroy
    5.times{ PastRecord.gen }
    3.times{ PastRecord.gen(steam: nil) }
    PastRecord.all(steam: nil).each do |record|
      Prediction.create(predicted_for: record.recorded_at, steam: 1000.5)
    end
    
    get '/records.json'
    
    json = MultiJson.load(last_response.body)
    assert_equal 8, json.count
    assert_equal 1000.5, json.last['steam']
  end
  
end