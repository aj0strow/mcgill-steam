namespace :db do
  def db_name
    env = ENV['RACK_ENV'] || 'development'
    "mcgill_steam_#{env}"
  end
  
  desc 'create Postgres database for the RACK_ENV'
  task :create do
    system "createdb -E UTF8 -w -O mcgill_steam #{db_name}"
    puts 'database created'
  end
  
  desc 'drop Postgres database for the RACK_ENV'
  task :drop do
    system "dropdb #{db_name}"
    puts 'database dropped'
  end
end