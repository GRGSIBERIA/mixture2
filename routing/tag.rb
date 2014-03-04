#-*- encoding: utf-8
def routing_tag
  get '/tag/new' do 
    slim :new_tag
  end

  # params tag_name
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

  # params tag_id
  # params category_name
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
  # params post_id
  # params user_id
  # params tag_id
  post '/tag/vote' do 
    begin
      tag_id = params[:tag_id].to_i
      post_id = params[:post_id].to_i
      user_id = params[:user_id].to_i
      Tag.vote_tag(tag_id, post_id, user_id)
    rescue ArgumentError => e
      halt 400, e.message
    end
    "succeeded"
  end

  get '/tag/vote' do 
    slim :vote_tag
  end

  post '/tag/unvote' do 
    begin
      tag_id = params[:tag_id].to_i
      post_id = params[:post_id].to_i
      user_id = params[:user_id].to_i
      Tag.unvote_tag(tag_id, post_id, user_id)
    rescue ArgumentError => e
      halt 400, e.message
    end
    "succeeded"
  end

  get '/tag/unvote' do 
    slim :unvote_tag
  end
end