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

  end

  def self.create(user_id, file_hash, extension)
    post = Post.new(
      user_id: user_id, 
      file_hash: file_hash, 
      extension: extension,
      created_at: Time.now.to_s)
    post.save
  end

  def self.call_order_query(page_num, order_by)
    offset = page_num.to_i * NUMBER_OF_CONTENTS_PER_PAGE
    DB[:posts]
      .select(:id, :file_hash, :extension, :created_at)
      .order(order_by)
      .offset(offset)
      .limit(NUMBER_OF_CONTENTS_PER_PAGE)
  end

  def self.order_by_old(page_num=0)
    Post.call_order_query(page_num, Sequel.asc(:id))
  end

  def self.order_by_new(page_num=0)
    Post.call_order_query(page_num, Sequel.desc(:id))
  end

  def self.tags(id, page_num=0)
    # これで動くか全くわからない, 要テスト
    post_tags = DB[:post_tags]
      .where(post_id: id.to_i)
      .join_table(:inner, DB[:tags], id: :tag_id)
    # 吐き出されるハッシュが不明なので要検証
  end
end