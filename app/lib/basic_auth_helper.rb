# frozen_string_literal: true

module BasicAuthHelper
  def authenticate
    authenticate_with_http_basic do |username, password|
      if user = User.find_by_email(username)
        validate_user(user, password)
      else
        request_http_basic_authentication
      end
    end
  end

  def validate_user(user, password)
    @current_user = user.authenticate(password)
    request_http_basic_authentication if @current_user.blank?
  end
end
