module AuthHelper

  DEFAULT_PASSWORD = 'test'

  def login_headers(username, password = DEFAULT_PASSWORD)
    { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
  end 
end
