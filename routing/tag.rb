#-*- encoding: utf-8
def raise_helper(e)
  begin
    raise e, e.message
  rescue ArgumentError => e
    halt 400, e.message
  rescue Sequel::ForeignKeyConstraintViolation => e 
    var = not_found_foreign_key(e)
    halt 400, "#{var}(#{eval(var)}) is not found."
  end
end

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
    tag = nil
    begin
      tag_id = params[:tag_id].to_i
      category_name = params[:category_name]
      tag = Tag.change_category(tag_id, category_name)
    rescue ArgumentError => e
      halt 400, e.message
    end
    "succeeded #{tag.category_id}"
  end

  post '/tag/attach' do 
    post_tag = nil
    begin
      tag_id  = params[:tag_id]
      post_id = params[:post_id]
      post_tag = PostTag.check_as_create(post_id, tag_id)
    rescue => e
      raise_helper(e)
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
      vote_unvote = params[:vote_unvote].to_i
      VoteTag.check_as_create(post_tag_id, user_id, vote_unvote)
    rescue => e
      raise_helper(e)
    end
  end

  get '/tag/vote' do 
    slim :vote_tag
  end
end