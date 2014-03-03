#-*- encoding: utf-8
def routing_tag
  get '/tag/new' do 
    slim :new_tag
  end

  post '/tag/create' do 
    tag_name = params[:tag_name]
    begin 
      Tag.create(tag_name)
    rescue ArgumentError => e
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

  post '/tag/vote' do 
    
  end

  get '/tag/vote/:post_id' do 
    
  end
end