#-*- encoding: utf-8

def routing_category
  get '/category/new' do 
    slim :new_category
  end

  post '/category/new' do 
    category = nil
    begin
      category_name = params[:category_name]
      category = Category.find_create(category_name)
    rescue ArgumentError => e
      halt 400, e.message
    end
    "succeeded #{category.id}"
  end

  post '/category/attach' do 
    category_tag = nil
    begin
      category_id = params[:category_id].to_i
      tag_id = params[:tag_id].to_i
      category_tag = TagCategory.check_as_create(tag_id, category_id)
    rescue => e 
      raise_helper(e, params)
    end
    "succeeded #{category_tag.id}"
  end

  get '/category/attach' do 
    slim :attach_category
  end

  post '/category/vote' do 
    vote_category = nil
    begin 
      tag_category_id = params[:tag_category_id].to_i
      user_id = params[:user_id].to_i
      vote = params[:vote].to_i
      vote_category = VoteCategory.check_as_create(tag_category_id, user_id, vote)
    rescue ArgumentError => e 
      raise_helper(e, params)
    end
    "succeeded #{vote_category.id}"
  end

  get '/category/vote' do 
    slim :vote_category
  end

  get '/category/list' do
    Category.listing.to_json
  end

  get '/category/list/:page_num' do
    page_num = params[:page_num].to_i 
    Category.listing(page_num).to_json
  end

  get '/category/list/:page_num/:order' do 
    result = nil 
    begin
      page_num = params[:page_num].to_i
      order = params[:order]
      result = Category.listing(page_num, order)
    rescue ArgumentError => e 
      raise_helper(e, params)
    end
    result.to_json
  end

end