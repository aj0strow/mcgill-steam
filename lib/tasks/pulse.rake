namespace :pulse do
  def interpret_time(input)
    print 'Interpreted time: '
    time = case input
    when nil, ''
      DateTime.now
    when String
      DateTime.parse(input)
    else
      input.to_datetime
    end
    puts time.iso8601
    time
  end
  
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
  
  def fetch_and_save(datetime)
    print "Fetching and saving 24 hourly PastRecords from #{datetime}... "
    records = Pulse.fetch_records(datetime)
    records.map! do |attrs|
      record = PastRecord.first_or_new(recorded_at: attrs[:recorded_at])
      record.attributes = attrs
      record
    end
    try_to_save records
  end
  
  desc 'fetch pulse data for 48 hours'
  # time represents 48 hours, so +/- 24 hours
  task :fetch, [:time] => :environment do |task, args|
    datetime = interpret_time(args[:time])
    fetch_and_save(datetime - 1)
    fetch_and_save(datetime)
  end
  
  desc 'populate pulse data for each time in range'
  task :populate, [:start, :end] => :environment do |task, args|
    start_time = interpret_time(args[:start])
    end_time = interpret_time(args[:end])
    (start_time..end_time).step(1).each do |datetime|
      fetch_and_save(datetime)
    end
  end
  
  task :newest => :environment do
    puts "Newest record: #{ PastRecord.max(:recorded_at) }"
  end
  
  task :oldest => :environment do
    puts "Oldest record: #{ PastRecord.min(:recorded_at) }"
  end
  
  desc 'print newest and oldest record times'
  task :range => [ :newest, :oldest ]
end