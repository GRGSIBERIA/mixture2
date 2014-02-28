#-*- encoding: utf-8

def policy
  # 3時間以内にアップロード
  policy_document = <<EOS
{"expiration": #{(Time.now + 60 * 60 * 3).to_s},
  "conditions": [
    {"bucket": "mixture-posts"},
    ["starts-with", "$key", "uploads/"],
    {"acl": "public-read"},
    {"success_action_redirect": "http://localhost:3000/"},
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
  'http://localhost:3000/'
end

def routing_post
  get '/post/new' do 
    @policy = policy
    @signature = signature(@policy)
    @access_key = MIXTURE_FREE_ACCESS_KEY
    @fname_hash = file_name_hash(request)
    @host = host_url
    slim :new_post
  end

  get '/post/prepare' do 
    buf_policy = policy
    @render = {
      policy:     buf_policy,
      signature:  signature(buf_policy),
      access_key: MIXTURE_FREE_ACCESS_KEY,
      fname_hash: file_name_hash(request),
      host:       host_url
    }.to_json
    slim :render_simple
  end

  get '/post/succeeded/:fname_hash/:file_name/:user_hash' do 
    fname_hash = params[:fname_hash]
    file_name = params[:file_name]
    user_hash = params[:user_hash]
  end
end