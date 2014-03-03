#-*- encoding: utf-8
class VoteTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :tags
  many_to_one :users
  many_to_one :posts

  def validate
    super
    
  end

  def self.duplicate?(tag_id, post_id, user_id)
    vote_tag = VoteTag.where(post_id: post_id, tag_id: tag_id, user_id: user_id).first
    unless vote_tag.nil? then
      raise ArgumentError, "user(#{user_id}) was voted tag(#{tag_id}) for post(#{post_id})."
    end
    true
  end

  def self.create(tag_id, post_id, user_id)
    VoteTag.duplicate?(tag_id, post_id, user_id)

    vote = VoteTag.new(post_id: post_id, tag_id: tag_id, user_id: user_id)
    vote.validate
    unless vote.valid? then
      raise ArgumentError, vote.errors.full_messages.join('<br>')
    end
    vote.save!
    vote
  end
end