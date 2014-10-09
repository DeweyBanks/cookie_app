class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionHelper
  helper_method :current_user, :logged_in?, :authenticate

  include OauthHelper
  helper_method :oauth_uri_with_query_params_for
end
