require 'test_helper'

class PredictionTest < Test
  
  setup do
    @prediction = Prediction.gen
  end
  
  test 'updated_at is set' do
    @prediction.save
    assert @prediction.updated_at
  end
  
  test 'predicted_for required' do
    @prediction.predicted_for = nil
    refute @prediction.save
  end
  
  test 'steam required' do
    @prediction.steam = nil
    refute @prediction.save
  end
  
end