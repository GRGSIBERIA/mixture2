#-*- encoding: utf-8

def rooting_list
  ##################################################
  # Category
  ##################################################
  get '/list/category' do
    Category.listing.to_json
  end

  get '/list/category/:page_num' do
    page_num = params[:page_num].to_i 
    Category.listing(page_num).to_json
  end

  get '/list/category/:page_num/:order' do 
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

  ##################################################
  # Post
  ##################################################
  get '/list/post' do 
    Post.listing.to_json
  end

  get '/list/post/:page_num' do 
    page_num = params[:page_num].to_i
    Post.listing(page_num).to_json
  end

  get '/list/post/:page_num/:order' do 
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

  ##################################################
  # User
  ##################################################
  get '/user/list/new' do 
    User.order_by_new.to_json
  end

  get '/user/list/new/:page_num' do 
    User.order_by_new(params[:page_num]).to_json
  end

  get '/user/list/old' do 
    User.order_by_old.to_json
  end

  get '/user/list/old/:page_num' do 
    User.order_by_old(params[:page_num]).to_json
  end
end