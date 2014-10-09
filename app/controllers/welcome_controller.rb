class WelcomeController < ApplicationController
  def index
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      if user
        redirect_to(user_path(user))
      else
        session[:user_id] = nil
        redirect_to(login_path)
      end
    else
      redirect_to(login_path)
    end
  end
end
