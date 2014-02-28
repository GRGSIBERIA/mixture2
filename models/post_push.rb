#-*- encoding: utf-8

# 投稿準備のリクエストが来た時に作成される
class PostPush
  many_to_one :users

  def self.add(user_id, file_hash)
    
  end
end