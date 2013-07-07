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
  
end