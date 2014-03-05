#-*- encoding: utf-8
class PostTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :posts
  many_to_one :tags

  def validate
    super
    
  end

  def self.create(post_id, tag_id)
    post_tag = PostTag.where(post_id: post_id, tag_id: tag_id).first
    if post_tag.nil? then
      # 存在しない場合は新しく作成
      post_tag = PostTag.new(post_id: post_id, tag_id: tag_id, created_at: Time.now.to_s)
      post_tag.validate
      raise ArgumentError, post_tag.errors.full_messages.join("<br>") unless post_tag.valid?      
      post_tag.save
    end
    post_tag
  end
end