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
end