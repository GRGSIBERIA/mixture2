#-*- encoding: utf-8

def file_name_hash(request)
  Digest::SHA256.hexdigest(request.ip.to_s + Time.now.to_s)
end

def host_url
  'http://localhost:3000'
end

def redirect_url(host_url, user_name)
  "#{host_url}/post/done/#{user_name}"
end

def routing_post
  get '/post/done/:user_id' do 
    file_hash = File.basename(params[:key], ".*")
    extension = File.extname(params[:key])
    user_id = params[:user_id].to_i

    Post.create(user_id, file_hash, extension)
    "succeeded #{file_hash}"
  end

  get '/post/new/:user_id' do 
    @access_key = MIXTURE_FREE_ACCESS_KEY
    @fname_hash = file_name_hash(request)
    @policy = s3_policy(redirect_url(host_url, params[:user_id]))
    @signature = s3_signature(@policy)
    @redirect = host_url

    @user_id = params[:user_id]
    if User.find(@user_id).nil? then
      halt 400, "BadRequest(user_id)"
    end

    slim :new_post
  end

  get '/post/prepare/:user_id' do 
    user = User.find(params[:user_id])
    @render = ""
    if user.nil? then
      halt 400, "BadRequest(user_id)"
    else
      file_hash = file_name_hash(request)
      buf_policy = s3_policy(redirect_url(host_url, user.id))
      @render = {
        policy:     buf_policy,
        signature:  s3_signature(buf_policy),
        access_key: MIXTURE_FREE_ACCESS_KEY,
        fname_hash: file_hash,
        host:       host_url
      }.to_json
    end
    slim :render_simple
  end

  get '/post/listing/:user_id' do 
    posts = User.posts(params[:user_id]).to_json
  end
end