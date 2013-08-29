namespace :predictions do
  OFFSET = 3
  
  def svm_model
    File.expand_path('tmp/svmModel.RData')
  end
  
  def training_csv
    File.expand_path('tmp/training.csv')
  end
  
  def forecast_csv
    File.expand_path('tmp/forecast.csv')
  end
  
  def predictions_csv
    File.expand_path('tmp/predictions.csv')
  end
  
  desc 'generate and save training data to csv'
  task :training_csv => :environment do
    print 'Generating training data... '
    csv = Predictions.generate_training_csv
    IO.write(training_csv, csv)
    puts 'complete!'
  end
  
  desc 'train and overwrite svm model with csv'
  task :train_model => :training_csv do
    script = File.expand_path('bin/trainModel.r')
    system "Rscript #{script} #{training_csv} #{svm_model} #{OFFSET}"
  end
  
  desc 'generate and save weather forecast csv'
  task :forecast_csv, [:amount] => :environment do |task, args|
    print 'Writing weather forecast... '
    amount = args[:amount] || 27
    csv = Predictions.generate_weather_forecast_csv(amount.to_i)
    IO.write(forecast_csv, csv)
    puts 'complete!'
  end
  
  desc 'save csv steam predictions to database'
  task :save => :environment do
    print 'Saving predictions... '
    predictions = IO.read(predictions_csv)
    Predictions.save_predictions(predictions)
    puts 'complete!'
  end
  
  desc 'predict steam from weather forecast csv'
  task :steam, [:hours] do |task, args|
    hours = args[:hours] || 24
    Rake::Task['predictions:forecast_csv'].invoke(hours.to_i + OFFSET)
    script = File.expand_path('bin/predict.r')
    system "Rscript #{script} #{svm_model} #{forecast_csv} #{predictions_csv} #{OFFSET}"
  end
  
  desc 'predict and save steam predictions'
  task :generate => :environment do
    hours = PastRecord.count(steam: nil)
    Rake::Task['predictions:steam'].invoke(hours.to_i)
    Rake::Task['predictions:save'].invoke()
  end
end