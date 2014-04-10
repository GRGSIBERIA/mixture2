#-*- encoding: utf-8
class PostTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :posts
  many_to_one :tags
  one_to_many :vote_tags

  def validate
    super
    validates_presence [:post_id, :tag_id]

    validates_integer :post_id
    validates_integer :tag_id
  end

  def self.check_as_create(post_id, tag_id)
    Model.find_or_create(PostTag, 
      {post_id: post_id, tag_id: tag_id},
      {post_id: post_id, tag_id: tag_id, created_at: Time.now.to_s})
  end
end