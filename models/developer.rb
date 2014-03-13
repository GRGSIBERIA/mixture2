#-*- encoding: utf-8
require './helpers/crypt.rb'

class Developer < Sequel::Model
  plugin :validation_helpers
  one_to_one :users

  def validate
    super

    validates_presence [:user_id, :secret_key, :consumer_key]
    
    validates_unique :user_id
  end

end