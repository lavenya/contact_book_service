# frozen_string_literal: true

module AuthHelper

  DEFAULT_PASSWORD = 'test'
  INVALID_PASSWORD = 'invalid'

  def login_headers(username, password = DEFAULT_PASSWORD)
    { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
  end 
end
