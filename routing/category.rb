#-*- encoding: utf-8

def routing_cotegory
  get '/category/new' do 
    slim :new_category
  end

  post '/category/create' do 
    category_name = params[:category_name]
    begin
      Category.create(category_name)
    rescue ArgumentError => e
      halt 400, e.message
    end
    category_name
  end
end