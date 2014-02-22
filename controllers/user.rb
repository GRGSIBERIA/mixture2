require 'digest/sha2'
require './models/user.rb'

module Controller
  class User
    include Crypt

    def self.create(params)
      user = Models::User.new(params)
      user.insert!
    end
  end
end