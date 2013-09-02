require 'sinatra'
require_relative 'lib/models'
require 'multi_json'

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

require_relative 'config/carrierwave'
require_relative 'lib/pulse'
require_relative 'lib/predictions'

get '/' do
  erb :index
end

get '/records.json' do
  days = params[:days].to_i
  days = 10 if days <= 0
  records = PastRecord.all(:order => :recorded_at.desc, :limit => days * 24).to_a.reverse
  structs = records.map do |record|
    steam = record.steam || Prediction.for(record.recorded_at).steam
    { datetime: record.recorded_at.to_time.utc.iso8601, steam: steam.round }
  end
  content_type :json
  MultiJson.dump(structs)
end