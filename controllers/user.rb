require 'digest/sha2'
require './models/user.rb'

module Controller
  class User
    

    def self.create(params)
      user = Model::User.new params
    end
  end
end