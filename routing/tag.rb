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

  post '/tag/attach' do 
    post_tag = nil
    begin
      tag_id  = params[:tag_id]
      post_id = params[:post_id]
      post_tag = PostTag.check_as_create(post_id, tag_id)
    rescue ArgumentError => e
      halt 400, e.message
    rescue Sequel::ForeignKeyConstraintViolation => e 
      var = not_found_foreign_key(e)
      halt 400, "#{var}(#{eval(var)}) is not found."
    end
  end

  get '/tag/attach' do 
    slim :attach_tag
  end
end