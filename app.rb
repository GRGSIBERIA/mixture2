require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'json'
require 'mysql2'
require 'sequel'
require 'yaml'

require './helpers/connector.rb'

DB = Connector.mysql

class Server < Sinatra::Base
  configure :development do
    register Sinatra::Reloader 
  end

  get '/' do 
    slim :index
  end

  get '/user/new' do 
    slim :new_user
  end

  post '/user/create' do 

  end

  get '/user/:id' do 

  end

  get '/users' do 
    @users = DB[:users].all

    content_type :json
    @users.to_json
  end


end


Server.run! port: 3000