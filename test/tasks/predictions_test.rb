require 'test_helper'

class PredictionsTest < Test
  
  test 'generate CSV' do
    training_data = Predictions.generate_training_data
    assert_equal training_data.split("\n"), 'Date,Hour,Temp,Radiation,Humidity,WindSpeed,Steam'
  end
  
  
  
end