require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'json'
require 'mysql2'
require 'sequel'
require 'yaml'

dbconfig = YAML::load_file("./config/database.yml")
Sequel::Model.plugin(:schema)
dbopts = Hash.new
mode = "development"
dbopts[:host] = dbconfig[mode]["host"]
dbopts[:user] = dbconfig[mode]["username"]
dbopts[:password] = dbconfig[mode]["password"]
dbopts[:database] = dbconfig[mode]["database"]
dbopts[:encoding] = dbconfig[mode]["encoding"]
DB = Sequel.mysql(nil, dbopts)

class Server < Sinatra::Base
  configure :development do
    register Sinatra::Reloader 
  end

  get '/' do 
    slim :index
  end

  get '/users' do 
    @users = User.all

    content_type :json
    @users.to_json
  end
end


Server.run! port: 3000