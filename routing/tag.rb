#-*- encoding: utf-8
def routing_tag
  get '/tag/new' do 
    slim :new_tag
  end

  post '/tag/create' do 
    tag_name = params[:tag_name]
    begin 
      Tag.create(name: tag_name, category_id: 1, created_at: Time.now.to_s)
    rescue Sequel::ValidationFailed => e
      halt 400, e.message
    end
    tag_name
  end

  get '/tag/change/category_id' do 
    slim :change_category
  end

  post '/tag/change/category' do 
    tag_id = params[:tag_id].to_i
    category_name = params[:category_name]
    begin
      Tag.change_category(tag_id, category_name)
    rescue ArgumentError => e
      halt 400, e.message
    end
    "succeeded"
  end

  # あくまで投票するだけで，追加はできない
  post '/tag/vote' do 
    begin
      user_id = params[:user_id].to_i
      tag_id  = params[:tag_id].to_i
      post_id = params[:post_id].to_i
      post_tag = PostTag.check_as_create(post_id, tag_id)
      vote_tag = VoteTag.check_as_create(post_tag, user_id, vote_unvote)
    rescue ArgumentError => e
      halt 400, e.message
    rescue Sequel::ForeignKeyConstraintViolation => e 
      
    end
    "succeeded"
  end

  get '/tag/vote_tag' do 
    slim :vote_tag
  end
end