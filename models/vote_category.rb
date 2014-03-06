#-*- encoding: utf-8
class VoteCategory < Sequel::Model
  plugin :validation_helpers
  many_to_one :users
  many_to_one :tag_categories

  def validate
    super
    
    validates_presence [:user_id, :vote, :tag_category_id]

    validates_includes [1, -1], :vote

    validates_integer :user_id
    validates_integer :vote
    validates_integer :tag_category_id
  end

  def self.check_as_create(tag_category_id, user_id, vote)
    # 既に同じユーザが同じタグに投票したかチェックする
    VoteTag.find_or_create(tag_category_id: tag_category_id, user_id: user_id) { |vote_category| 
      vote_category.tag_category_id = tag_category_id
      vote_category.user_id = user_id
      vote_category.vote = vote
      vote_category.validate
      raise ArgumentError, vote_category.errors.full_messages.join("<br>") unless vote_category.valid?
    }
  end
end