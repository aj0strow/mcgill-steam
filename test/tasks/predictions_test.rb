require 'test_helper'

class PredictionsTest < Test
  test 'save predictions from CSV' do
    Prediction.all.destroy
    predictions_csv = [
      '"Date","SteamForecast"',
      '"2013-02-27T00:00-04:00","32977.107362766"',
      '"2013-02-27T01:00-04:00","32778.3239391544"',
      '"2013-02-27T02:00-04:00","35496.1768815789"'
    ].join("\n")
    Predictions.save_predictions(predictions_csv)
    assert_equal 3, Prediction.count
    assert_equal 32977.107362766, Prediction.first.steam    
  end
end