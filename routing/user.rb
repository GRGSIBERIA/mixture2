#-*- encoding: utf-8
def routing_user
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

  get '/user/new' do 
    slim :new_user
  end

  get '/user/succeed' do 
    slim :create_user_succeed
  end

  post '/user/create' do 
    @user = User.add(params)

    @user.validate
    unless @user.valid? then
      halt 400, "Invalid Parameters!"
    else
      #puts @user[:nickname].encoding
      @user.save
      session[:user_id] = @user.id
      session[:user_name] = @user.name
      session[:apikey] = Crypt.make_apikey(@user)
      redirect '/user/succeed'
    end
  end

  get '/user/:id' do 
    @user = User.find(params[:id])
    @posts = User.posts(params[:id])
    slim :user_info
  end
end