#-*- encoding: utf-8
class Post < Sequel::Model
  plugin :validation_helpers
  many_to_one :users
  one_to_many :vote_tags
  one_to_many :vote_categories
  one_to_many :post_tags
  one_to_many :thumbnails

  def validate
    super
    validates_presence [:user_id, :file_hash, :extension, :created_at]
    validates_integer :user_id
    validates_type String, [:file_hash, :extension]
  end

  def self.create(user_id, file_hash, extension)
    post = Post.new(
      user_id: user_id, 
      file_hash: file_hash, 
      extension: extension,
      created_at: Time.now.to_s)
    post.validate
    raise ArgumentError, post.errors.full_messages unless post.valid?
    post.save
    post
  end

  def self.listing(page_num=0, order="desc")
    ListingHelper.listing_basic(:posts, :contents, page_num, order)
  end

  def self.tags(id, page_num=0)
    # これで動くか全くわからない, 要テスト
    post_tags = PostTag.where(post_id: id.to_i)
      .join_table(:inner, Tag, id: :tag_id)
    # 吐き出されるハッシュが不明なので要検証
  end
end