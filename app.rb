#-*- encoding: utf-8
require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'json'
require 'mysql2'
require 'sequel'
require 'yaml'
require 'moji'
require 'digest/sha2'

INVALID_WORDS = %w(index home top help about security contact connect support faq form mail update mobile phone portal tour tutorial navigation navi manual doc company store shop topic news information info howto pr press release sitemap plan price business premium member term privacy rule inquiry legal policy icon image img photo css stylesheet style script src js javascript dist asset source static file flash swf xml json sag cgi account user item entry article page archive tag category event contest word product project download video blog diary site popular i my me owner profile self old first last start end special design theme purpose book read organization community group all status state search explore share feature upload rss atom widget api wiki bookmark captcha comment jump ranking setting config tool connect notify recent report system sys message msg log analysis query call calendar friend graph watch cart activity auth session register login logout signup forgot admin root secure get show create edit update post destroy delete remove reset error new dashboard recruit join offer career corp cgi-bin server-status balancer-manager ldap-status server-info svn as by if is on or add dir off out put case else find then when count order select switch school developer dev test bug code guest app maintenance roc id bot game forum contribute usage feed ad service official language repository spec license asct dictionary dict version ver gift alpha beta tux year public private default request req data master die exit eval undef nan null empty 0 www)
#Encoding.default_external = Encoding::UTF_8  
#Encoding.default_internal = Encoding::UTF_8  

NUMBER_OF_CONTENTS_PER_PAGE = 20
NUMBER_OF_WORDS_PER_PAGE = 50

require './aws.rb'
require './salt.rb'
require './helpers/connector.rb'
require './helpers/crypt.rb'
require './helpers/validation.rb'
require './helpers/exception.rb'
DB = Connector.mysql # Modelを読み込むより先に実行する必要がある

require './models/user.rb'
require './models/post.rb'
require './models/tag.rb'
require './models/category.rb'
require './models/vote_tag.rb'
require './models/vote_category.rb'
require './models/post_tag.rb'

require './helpers/verify.rb' # DBを利用するためモデルの後に読み込む
Sequel::Model.plugin :json_serializer

require './routing/user.rb'
require './routing/post.rb'


class Server < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    enable :sessions
    #encoding = "utf-8"
  end

  get '/' do 
    slim :index
  end
  
  routing_user
  routing_post
end


Server.run! port: 3000