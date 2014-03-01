#-*- encoding: utf-8
class PostTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :posts
  many_to_one :tags

  def validate
    super
    
  end

  def self.vote(post_id, tag_id)
    post_tag = DB[:post_tags].where(past_id: post_id).where(tag_id: tag_id).first
    if post_tag.nil? then
      post_tag = PostTag.new(post_id: post_id, tag_id: tag_id, created_at: Time.now.to_s, updated_at: Time.now.to_s)
    end
    post_tag.count += 1
    post_tag.save
    post_tag
  end

  def self.unvote(post_tag_id)
    ptag = DB[:post_tags].where(id: post_tag_id.to_i).first
    if ptag.nil? then 
      halt 400, "Cannot find post_tag_id(#{post_tag_id})."
    end
    ptag.count -= 1
    ptag.save
    ptag
  end
end