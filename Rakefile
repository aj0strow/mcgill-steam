require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end

task default: :test

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require_relative 'app'
end

Dir.glob('lib/tasks/*.rake').each{ |task| import task }

task :hourly do
  Rake::Task['pulse:fetch'].invoke
  Rake::Task['predictions:generate'].invoke
end

task :weekly do
  Rake::Task['predictions:train_model'].invoke
end