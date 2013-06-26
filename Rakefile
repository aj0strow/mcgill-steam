require './lib/pulse'

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require './app'
end

namespace :pulse do
  task fetch: :environment do
    Pulse.fetch_points(Time.now)
  end
end