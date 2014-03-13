#-*- encoding: utf-8
require './helpers/crypt.rb'

class Developer < Sequel::Model
  plugin :validation_helpers
  one_to_one :users

  def validate
    super

    validates_presence [:user_id, :secret_key, :consumer_key]    

    validates_unique :user_id

    validates_integer :user_id
    validates_string  :secret_key
    validates_string  :consumer_key
  end

  def entry(user_id)
    user = User.find(user_id)
    raise ArgumentError, "user_id(#{user_id}) is not found" if user.nil?
    Developer.new(
      user_id: user_id,
      
      )
  end
end