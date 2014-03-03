#-*- encoding: utf-8
class VoteTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :tags
  many_to_one :users
  many_to_one :posts

  def validate
    super
    
    validates_presence [:user_id, :vote_unvote, :post_tag_id]

    validates_includes [1, -1], :vote_unvote

    validates_integer :user_id
    validates_integer :vote_unvote
    validates_integer :post_tag_id
  end

  def self.find_or_create(post_tag_id, user_id, vote_unvote)
    vote_tag = VoteTag.where(post_tag_id: post_tag_id, user_id: user_id).first
    unless vote_tag.nil? then
      raise ArgumentError, "user(#{user_id}) was voted tag(#{tag_id}) to post(#{post_id})."
    else
      vote_tag = VoteTag.new(post_tag_id: post_tag_id, user_id: user_id, vote_unvote: vote_unvote, created_at: Time.now.to_s)
      vote_tag.validate
      unless vote_tag.valid? then
        raise ArgumentError, vote_tag.errors.full_messages.join("<br>")
      end
      vote_tag.save
    end
    vote_tag
  end
end