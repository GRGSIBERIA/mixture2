#-*- encoding: utf-8

# 投稿準備のリクエストが来た時に作成される
class PostPush
  many_to_one :users

  def self.push(user_id, file_hash)
    pp = PostPush.new(user_id: user_id, file_hash: file_hash)
    pp.save
  end

  def self.find(file_hash)
    PostPush.where(file_hash: file_hash).first
  end
end