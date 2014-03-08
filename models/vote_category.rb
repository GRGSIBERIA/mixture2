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
    Model.find_or_create(VoteTag, 
      {tag_category_id: tag_category_id, user_id: user_id}, 
      {tag_category_id: tag_category_id, user_id: user_id, created_at: Time.now.to_s, vote: vote})
  end
end