#-*- encoding: utf-8
class PostTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :posts
  many_to_one :tags

  def validate
    super
    
  end
end