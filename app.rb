require 'sinatra'

set :public_folder, proc{ File.join(root, 'public') }
set :views, proc{ File.join(root, 'views') }

configure :development do
  require './lib/environment_variables'
end

get '/' do
  erb :index
end