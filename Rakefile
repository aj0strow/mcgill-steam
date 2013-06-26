require './lib/pulse'

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require './app'
end

namespace :pulse do
  task :fetch do
    fetch_points
  end
end