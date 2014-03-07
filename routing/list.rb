#-*- encoding: utf-8

def rooting_list
  get '/list/category' do 
    ListingHelper.basic_three_routing(Category, :none, params)
  end

  get '/list/category/:page_num' do 
    ListingHelper.basic_three_routing(Category, :page_num, params)
  end

  get '/list/category/:page_num/:order' do 
    ListingHelper.basic_three_routing(Category, :order, params)
  end



  get '/list/post' do 
    ListingHelper.basic_three_routing(Post, :none, params)
  end

  get '/list/post/:page_num' do 
    ListingHelper.basic_three_routing(Post, :page_num, params)
  end

  get '/list/post/:page_num/:order' do 
    ListingHelper.basic_three_routing(Post, :order, params)
  end


  
  get '/list/user' do 
    ListingHelper.basic_three_routing(User, :none, params)
  end

  get '/list/user/:page_num' do 
    ListingHelper.basic_three_routing(User, :page_num, params)
  end

  get '/list/user/:page_num/:order' do 
    ListingHelper.basic_three_routing(User, :order, params)
  end
end