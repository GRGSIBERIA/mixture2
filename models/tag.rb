#-*- encoding: utf-8
class Tag < Sequel::Model
  plugin :validation_helpers
  many_to_one :categories
  one_to_many :vote_tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name]

    validates_min_length 4,   :name
    validates_max_length 140, :name

    validates_unique :name
  end
end