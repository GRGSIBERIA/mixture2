#-*- encoding: utf-8
def routing_user
  get '/user/new' do 
    slim :new_user
  end

  post '/user/new' do 
    @user = nil
    @name = params[:name]
    @email = params[:email]
    begin
      password = params[:password]
      @user = User.check_as_create(@name, password, @email)
    rescue ArgumentError => e 
      @error_messages = e.message
      slim :new_user
    end
    slim :create_user_succeed
  end

  get '/user/:id' do 
    user_id = params[:id].to_i
    @user = User.find(id: user_id)
    @posts = User.posts(user_id)
    slim :user_info
  end
end