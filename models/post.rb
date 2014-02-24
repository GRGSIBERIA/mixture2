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

  def self.find(id)
    DB[:posts].where(id: id.to_i).first
  end

  def self.tags(id, page_num=0)
    # これで動くか全くわからない, 要テスト
    post_tags = DB[:post_tags]
      .where(post_id: id.to_i)
      .join_table(:inner, DB[:tags], id: :tag_id)
    # 吐出されるハッシュが不明なので要検証
  end
end