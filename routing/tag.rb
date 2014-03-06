#-*- encoding: utf-8
def routing_tag
  get '/tag/new' do 
    slim :new_tag
  end

  post '/tag/create' do 
    tag = nil
    begin 
      tag_name = params[:tag_name]
      tag = Tag.find_create(tag_name)
    rescue ArgumentError => e
      halt 400, e.message
    end
    "succeeded #{tag.id}"
  end

  post '/tag/attach' do 
    post_tag = nil
    begin
      tag_id  = params[:tag_id]
      post_id = params[:post_id]
      post_tag = PostTag.check_as_create(post_id, tag_id)
    rescue => e
      raise_helper(e, params)
    end
    "succeeded #{post_tag.id.to_s}"
  end

  get '/tag/attach' do 
    slim :attach_tag
  end

  post '/tag/vote' do 
    post_tag = nil
    begin
      post_tag_id = params[:post_tag_id].to_i
      user_id = params[:user_id].to_i
      vote = params[:vote].to_i
      post_tag = VoteTag.check_as_create(post_tag_id, user_id, vote)
    rescue => e
      raise_helper(e, params)
    end
    "succeeded #{post_tag.id}"
  end

  get '/tag/vote' do 
    slim :vote_tag
  end
end