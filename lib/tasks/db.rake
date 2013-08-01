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