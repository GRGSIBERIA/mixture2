#-*- encoding: utf-8
class PostTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :posts
  many_to_one :tags
  one_to_many :vote_tags

  def validate
    super
    
  end

  def self.check_as_create(post_id, tag_id)
    PostTag.find_or_create(post_id: post_id, tag_id: tag_id) { |post_tag| 
      post_tag.post_id = post_id
      post_tag.tag_id = tag_id
      post_tag.created_at = Time.now.to_s
      post_tag.validate
      raise ArgumentError, post_tag.errors.full_messages.join("<br>") unless post_tag.valid?      
      post_tag.save
    }
  end
end