namespace :pulse do
  def interpret_time(input)
    print 'Interpreted time: '
    time = case input
    when nil, ''
      Time.now
    when String
      Time.parse(input)
    else
      input.to_time
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
  
  # time represents 48 hours, so +/- 24 hours
  task :fetch, [:time] => :environment do |task, args|
    time = interpret_time(args[:time])
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