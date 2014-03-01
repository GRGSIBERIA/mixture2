#-*- encoding: utf-8

def policy(host_url, user_name)
  # 3時間以内にアップロード
  policy_document = <<EOS
{"expiration": "2113-08-17T00:00:00Z",
  "conditions": [
    {"bucket": "mixture-posts"},
    ["starts-with", "$key", "uploads/"],
    {"acl": "public-read"},
    {"success_action_redirect": "#{host_url}/post/done/#{user_name}"},
    ["starts-with", "$Content-Type", ""],
    ["content-length-range", 0, 1073741824]
  ]
}
EOS
 
  Base64.encode64(policy_document).gsub("\n","")
end

def signature(policy)
  aws_secret_key = MIXTURE_FREE_SECRET_KEY
  Base64.encode64(
    OpenSSL::HMAC.digest(
      OpenSSL::Digest::Digest.new('sha1'),
      aws_secret_key, policy)
    ).gsub("\n","")
end

def file_name_hash(request)
  Digest::SHA256.hexdigest(request.ip.to_s + Time.now.to_s)
end

def host_url
  'http://localhost:3000'
end


def routing_post
  get '/post/done/:user_id' do 
    file_hash = File.basename(params[:key], ".*")
    extension = File.extname(params[:key])
    user_id = params[:user_id].to_i

    Post.create(user_id, file_hash, extension)
  end

  get '/post/new/:user_id' do 
    @access_key = MIXTURE_FREE_ACCESS_KEY
    @fname_hash = file_name_hash(request)
    @policy = policy(host_url, params[:user_id])
    @signature = signature(@policy)
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
      buf_policy = policy(host_url, user.id)
      @render = {
        policy:     buf_policy,
        signature:  signature(buf_policy),
        access_key: MIXTURE_FREE_ACCESS_KEY,
        fname_hash: file_hash,
        host:       host_url
      }.to_json
    end
    slim :render_simple
  end

  get '/post/listing/:user_id' do 
    @users = User.posts(params[:user_id])
  end
end