#-*- encoding: utf-8

def routing_vote
  get '/vote/tag/new' do 
    slim :new_tag
  end

  get '/vote/category/new' do 
    slim :new_category
  end

  post '/vote/category/create' do 

  end

  post '/vote/tag/create' do 

  end

  get '/vote/post/:post_id/:tag_name' do 
    post_id = params[:post_id]
    tag_name = params[:tag_name]


  end

  get '/vote/category/:tag_id/:category_name' do 

  end
end