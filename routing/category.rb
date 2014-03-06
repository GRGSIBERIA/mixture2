#-*- encoding: utf-8

def routing_category
  get '/category/new' do 
    slim :new_category
  end

  post '/category/create' do 
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
      category_tag = TagCategory.find_create(tag_id, category_id)
    rescue 

    end
    "succeeded #{category_tag.id}"
  end

  get '/category/attach' do 
    slim :attach_category
  end

  get '/category/listing' do
    Category.listing.to_json
  end

  get '/category/listing/:page_num' do
    page_num = params[:page_num].to_i 
    Category.listing(page_num).to_json
  end

  get '/category/listing/:order/:page_num' do 
    result = nil 
    begin
      page_num = params[:page_num].to_i
      order = params[:order]
      result = Category.listing(page_num, order)
    rescue ArgumentError => e 
      halt 400, e.message
    end
    result.to_json
  end

end