#-*- encoding: utf-8
def routing_user
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
      @errors = @user.errors
      @username = params[:user_name]
      @nickname = params[:nickname]
      puts "Invalid Parameters!"
      slim :new_user
    else
      #puts @user[:nickname].encoding
      @user.save
      session[:user_name] = @user.name
      session[:apikey] = Crypt.make_apikey(@user)
      redirect '/user/succeed'
    end
  end

  get '/user/list' do 
    @users = DB[:users].all
    slim :user_list
  end

  get '/user/:id' do 

  end
end