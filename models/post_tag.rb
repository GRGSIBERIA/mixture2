#-*- encoding: utf-8
class PostTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :posts
  many_to_one :tags

  def validate
    super
    
  end

  def self.find_or_create(post_id, tag_id)
    post_tag = PostTag.where(post_id, tag_id).first
    if post_tag.nil? then
      # 存在しない場合は新しく作成
      post_tag = PostTag.new(post_id: post_id, tag_id: tag_id)
      post_tag.count = 1
      post_tag.save
    else
      # 存在する場合はアップデート
      post_tag = PostTag.where(id: post_tag.id).update(count: Sequel.+(:count, 1))
    end
    post_tag
  end
end