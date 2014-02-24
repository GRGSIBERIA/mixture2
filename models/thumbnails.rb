#-*- encoding: utf-8
class Thumbnail < Sequel::Model
  plugin :validation_helpers
  many_to_one :posts

  def validate
    super
    
  end
end