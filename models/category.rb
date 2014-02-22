#-*- encoding: utf-8
class Category < Sequel::Model
  plugin :validation_helpers
  one_to_many :tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name]

    validates_min_length 4,   :name
    validates_max_length 140, :name
  end
end