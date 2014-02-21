require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'

require_relative 'models/init.rb'

class Server < Sinatra::Base
  configure :development do
    register Sinatra::Reloader 
  end

  get '/' do 
    slim :index
  end
end

Server.run! port: 3000