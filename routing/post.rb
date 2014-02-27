#-*- encoding: utf-8

def policy
  policy_document = <<EOS
{"expiration": "2113-08-17T00:00:00Z",
  "conditions": [
    {"bucket": "mixture-posts"},
    ["starts-with", "$key", "uploads/"],
    {"acl": "private"},
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

def routing_post
  get '/post/new' do 
    @policy = policy
    @signature = signature(@policy)
    @access_key = MIXTURE_FREE_ACCESS_KEY
    @fname_hash = file_name_hash(request)

    slim :new_post
  end

  get '/post/prepare' do 
    buf_policy = policy
    @render = {
      policy:     buf_policy,
      signature:  signature(buf_policy),
      access_key: MIXTURE_FREE_ACCESS_KEY,
      fname_hash: file_name_hash(request)
    }.to_json
    slim :render_simple
  end
end