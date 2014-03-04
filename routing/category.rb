#-*- encoding: utf-8

def routing_category
  get '/category/new' do 
    slim :new_category
  end

  post '/category/create' do 
    category_name = params[:category_name]
    begin
      Category.create(name: category_name, created_at: Time.now.to_s)
    rescue ArgumentError => e
      halt 400, e.message
    end
    category_name
  end
end