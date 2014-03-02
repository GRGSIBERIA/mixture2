#-*- encoding: utf-8

def routing_vote
  get '/vote/tag/new' do 
    slim :new_tag
  end

  get '/vote/category/new' do 
    slim :new_category
  end

  post '/vote/category/create' do 
    category_name = params[:category_name]
    begin
      Category.create(category_name)
    rescue ArgumentError => e
      halt 400, e.message
    end
    category_name
  end

  post '/vote/tag/create' do 
    tag_name = params[:tag_name]
    begin 
      Tag.create(tag_name)
    rescue ArgumentError => e
      halt 400, e.message
    end
    tag_name
  end

  get '/vote/post/:post_id/:tag_name' do 
    post_id = params[:post_id]
    tag_name = params[:tag_name]


  end

  get '/vote/category/:tag_id/:category_name' do 

  end
end