#-*- encoding: utf-8

# 投稿準備のリクエストが来た時に作成される
class PostPush
  many_to_one :users

  def self.add(user_id, file_hash)
    pp = PostPush.new(user_id: user_id, file_hash: file_hash)
    pp.save
  end
end