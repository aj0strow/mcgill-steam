require 'sinatra'
require_relative 'lib/models'

set :public_folder, proc{ File.join(root, 'public') }
set :views, proc{ File.join(root, 'views') }

configure :production do
  DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_GOLD_URL'])
end

configure :development do
  require_relative 'config/environment_variables'
  DataMapper.setup(:default, 'postgres://mcgill_steam@localhost/mcgill_steam_development')
end

configure :test do
  require_relative 'config/environment_variables'
  DataMapper.setup(:default, 'postgres://mcgill_steam@localhost/mcgill_steam_test')
  DataMapper.auto_migrate!
end

DataMapper.auto_upgrade!

require_relative 'lib/pulse'


get '/' do
  erb :index
end