#-*- encoding: utf-8
class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :posts
  one_to_many :vote_tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name, :email, :password, :nickname]

    validates_length_range 4..80, :name
    validates_length_range 4..80, :nickname

    validates_unique [:name, :email]

    validates_format(/\A\w+\z/, :name)
    validates_format(/\A[\wぁ-んァ-ヴ一-龠、-◯]\z/, :nickname)
  end
end