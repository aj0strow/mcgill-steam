namespace :records do
  task :newest => :environment do
    puts "Newest record: #{ PastRecord.max(:recorded_at) }"
  end
  
  task :oldest => :environment do
    puts "Oldest record: #{ PastRecord.min(:recorded_at) }"
  end
  
  desc 'print newest and oldest record times'
  task :range => [ :newest, :oldest ]
  
  desc 'print out gaps where PastRecords dont exist'
  task :gaps => :environment do
    print 'Finding gaps in PastRecords: '
    times = PastRecord.all(fields: [:recorded_at]).map(&:recorded_at).sort
    hour = Rational(1, 24)
    gaps = times.each_cons(2).select{ |a, b| b - a > hour }
    if gaps.any?
      puts ''
      gaps.each{ |a, b| puts "#{a.iso8601} -> #{b.iso8601}" }
    else
      puts 'none!'
    end
  end
end