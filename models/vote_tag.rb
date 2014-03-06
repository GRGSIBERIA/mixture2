#-*- encoding: utf-8
class VoteTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :users
  many_to_one :post_tags

  def validate
    super
    
    validates_presence [:user_id, :vote, :post_tag_id]

    validates_includes [1, -1], :vote

    validates_integer :user_id
    validates_integer :vote
    validates_integer :post_tag_id
  end

  def self.check_as_create(post_tag_id, user_id, vote)
    # 既に同じユーザが同じタグに投票したかチェックする
    VoteTag.find_or_create(post_tag_id: post_tag_id, user_id: user_id) { |vote_tag| 
      vote_tag.post_tag_id = post_tag_id
      vote_tag.user_id = user_id
      vote_tag.vote = vote
      vote_tag.validate
      raise ArgumentError, vote_tag.errors.full_messages.join("<br>") unless vote_tag.valid?
    }
  end
end