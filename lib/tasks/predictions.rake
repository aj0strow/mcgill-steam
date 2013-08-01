namespace :predictions do
  def svm_model
    File.expand_path('bin/svmModel.RData')
  end
  
  def training_csv
    File.expand_path('bin/csv/training.csv')
  end
  
  def forecast_csv
    File.expand_path('bin/csv/forecast.csv')
  end
  
  def predictions_csv
    File.expand_path('bin/csv/predictions.csv')
  end
  
  task :training_csv => :environment do
    print 'Generating training data... '
    csv = Predictions.generate_training_csv
    IO.write(training_csv, csv)
    puts 'complete!'
  end
  
  task :forecast_csv, [:amount] => :environment do |task, args|
    print 'Writing weather forecast... '
    amount = args[:amount] || 27
    csv = Predictions.generate_weather_forecast_csv(amount.to_i)
    IO.write(forecast_csv, csv)
    puts 'complete!'
  end
  
  task :save => :environment do
    print 'Saving predictions... '
    predictions = IO.read(predictions_csv)
    Predictions.save_predictions(predictions)
    puts 'complete!'
  end
  
  task :train_model => :training_csv do
    system "Rscript bin/trainModel.r #{training_csv} #{svm_model} 3"
  end
  
  task :steam, [:hours, :offset] do |task, args|
    hours = args[:hours] || 24
    offset = args[:offset] || 3
    Rake::Task['predictions:forecast_csv'].invoke(hours.to_i + offset.to_i)
    `Rscript bin/predict.r #{svm_model} #{forecast_csv} #{predictions_csv} #{offset}`
  end
  
  task :generate, [:offset] => :environment do |task, args|
    hours = PastRecord.count(steam: nil)
    offset = args[:offset] || 3
    Rake::Task['predictions:steam'].invoke(hours.to_i, offset.to_i)
    Rake::Task['predictions:save'].invoke()
  end
end