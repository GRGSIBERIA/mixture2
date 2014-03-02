#-*- encoding: utf-8

def routing_vote
  get '/vote/tag/new' do 

  end

  get '/vote/category/new' do 
    
  end

  get '/vote/post/:post_id/:tag_name' do 
    post_id = params[:post_id]
    tag_name = params[:tag_name]

    
  end

  get '/vote/category/:tag_id/:category_name' do 

  end
end