#-*- encoding: utf-8
def routing_user
  get '/user/new' do 
    slim :new_user
  end

  post '/user/new' do 
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

  get '/user/succeed' do 
    slim :create_user_succeed
  end

  get '/user/:id' do 
    user_id = params[:id].to_i
    @user = User.find(id: user_id)
    @posts = User.posts(user_id)
    slim :user_info
  end
end