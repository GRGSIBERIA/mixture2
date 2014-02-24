#-*- ecnoding: utf-8
module Verify
  def has_apikey(params)
    key = params[:apikey]
    name = params[:user_name]
    user = DB[:user].where(name: name).first
    
    if user.nil? then
      raise UserNotFound, "#{name} is not found."
    end
    
    collate = Crypt.make_apikey(user)

    if key != collate then
      raise InvalidAPIKey, "Invalid API Key."
    end
    true
  end
end