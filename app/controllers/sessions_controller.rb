class SessionsController < ApplicationController
  def new
    set_oauth_redirect_uri_for request.host, request.port
    @google_oauth_link = oauth_uri_with_query_params_for :Google
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      log_in(user)
      redirect_to(user_path(user))
    else
      flash[:error] = "Incorrect username or password."
      redirect_to(login_path)
    end
  end

  def oauth_create
    if request_state_equals_stored_state
      get_access_token_for :Google
      clear_session_state
      authorization_info = get_user_info_from :Google

      user = User.find_by(email: authorization_info[:email])

      unless user # email doesn't exist in database
        # create the user
        user = User.create({
          name:     authorization_info[:name],
          email:    authorization_info[:email],
          role:     'customer',
          password: 'changeme'# SecureRandom.hex
        })
        user.favorite_recipe = Recipe.first
        user.save

        # this part would be more complex in a real app...
        # forcing the user to change their password immediately, etc.
      end
      log_in(user)
      redirect_to user_path(user)
    else
      session[:handshake_failed] = true
      redirect_to('/')
    end
  end

  def destroy
    log_out!
    redirect_to(login_path)
  end
end
