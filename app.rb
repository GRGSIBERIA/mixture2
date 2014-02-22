require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'json'
require 'mysql2'
require 'sequel'
require 'yaml'

require './salt.rb'

#require './models/base.rb'
require './models/user.rb'
require './models/post.rb'
require './models/tag.rb'
require './models/category.rb'
require './models/vote_tag.rb'
require './models/vote_category.rb'
require './models/post_tag.rb'

require './helpers/connector.rb'
require './helpers/crypt.rb'

require './controllers/user.rb'

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
    @user = Controller::User.create(params)
    redirect '/'
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