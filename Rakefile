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
  def try_to_save(records)
    if records.all?(&:valid?)
      records.each(&:save)
      puts 'complete!'
    else
      puts '!!!'
      errors = records.map do |record|
        record.errors.full_messages.join(', ')
      end
      puts errors.reject(&:empty?).join("\n")
    end
  end
  
  task :fetch, [:time] => :environment do |task, args|
    print 'Interpreted time: '
    time = case (input = args[:time])
    when nil, ''
      Time.now
    when String
      Time.parse(input)
    else
      input.to_time
    end
    puts time.iso8601
    print 'Fetching and creating PastRecords... '
    day = 60 * 60 * 24
    records = Pulse.fetch_records(time) + Pulse.fetch_records(time - day)
    records.map! do |attrs|
      record = PastRecord.first_or_new(recorded_at: attrs[:recorded_at])
      record.attributes = attrs
      record
    end
    try_to_save records
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