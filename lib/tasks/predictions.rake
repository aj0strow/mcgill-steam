namespace :predictions do
  OFFSET = 3
  
  # write to cloud
  def write(filename, string)
    IO.write filename, string
    push filename
  end
  
  # push file to cloud
  def push(*filename)
    filenames.each do |filename|
      File.open(filename, 'r'){ |f| Uploader.new.store! f }
    end
  end
  
  # pull file from cloud
  def pull(*filenames)
    uploader = Uploader.new
    filenames.each do |filename|
      uploader.retrieve_from_store!(File.basename filename)
      IO.write filename, uploader.file.read
    end
  end

  def training_csv
    path_to 'training.csv'
  end
  
  def forecast_csv
    path_to 'forecast.csv'
  end
  
  def predictions_csv
    path_to 'predictions.csv'
  end
  
  def svm_model
    path_to 'svmModel.RData'
  end
  
  def path_to(filename)
    File.expand_path File.join('tmp', filename)
  end
  
  task :training_csv => :environment do
    print 'Generating training data... '
    csv = Predictions.generate_training_csv
    write(training_csv, csv)
    puts 'complete!'
  end
  
  desc 'train and overwrite svm model'
  task :train_model => :training_csv do
    pull training_csv
    script = File.expand_path('bin/trainModel.r')
    system "Rscript #{script} #{training_csv} #{svm_model} #{OFFSET}"
    push svm_model
  end
  
  task :forecast_csv, [:amount] => :environment do |task, args|
    print 'Writing weather forecast... '
    amount = args[:amount] || 27
    csv = Predictions.generate_weather_forecast_csv(amount.to_i)
    write(forecast_csv, csv)
    puts 'complete!'
  end
  
  task :save => :environment do
    print 'Saving predictions... '
    pull predictions_csv
    predictions = IO.read(predictions_csv)
    Predictions.save_predictions(predictions)
    puts 'complete!'
  end
  
  task :steam, [:hours] do |task, args|
    hours = args[:hours] || 24
    Rake::Task['predictions:forecast_csv'].invoke(hours.to_i + OFFSET)
    pull svm_model, forecast_csv
    script = File.expand_path('bin/predict.r')
    system "Rscript #{script} #{svm_model} #{forecast_csv} #{predictions_csv} #{OFFSET}"
    push predictions_csv
  end
  
  desc 'predict and save steam predictions'
  task :generate => :environment do
    hours = PastRecord.count(steam: nil)
    Rake::Task['predictions:steam'].invoke(hours.to_i)
    Rake::Task['predictions:save'].invoke()
  end
  
  desc 'delete week old predictions'
  task :clean => :environment do
    old_predictions = Prediction.all(:predicted_for.lt => DateTime.now - 7)
    print "Destroying #{old_predictions.count} old predictions... "
    old_predictions.destroy
    puts 'complete!'
  end
end