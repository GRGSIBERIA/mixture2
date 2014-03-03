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

  get '/change/tag/category_id' do 
    slim :change_category
  end

  post '/change/tag/category' do 
    tag_id = params[:tag_id].to_i
    category_name = params[:category_name]
    begin
      Tag.change_category(tag_id, category_name)
    rescue ArgumentError => e
      halt 400, e.message
    end
    "succeeded"
  end
end