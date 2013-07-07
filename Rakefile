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

namespace :pulse do
  task fetch: :environment do
    Pulse.fetch_points(Date.today - 3)
  end
end

namespace :db do
  def db_name
    env = ENV['RACK_ENV'] || 'development'
    "mcgill_steam_#{env}"
  end
  
  task :create do
    system "createdb -E UTF8 -w -O mcgill_steam #{db_name}"
    puts 'database created'
  end
  
  task :drop do
    system "dropdb #{db_name}"
    puts 'database dropped'
  end
end