# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  #Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem

  skip_before_filter :login_required

  # render new.rhtml
  def new
    flash[:notice] = 'Please login or signup, to access the system'
    redirect_to root_path
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_to root_path
    else
      flash[:notice] = "Invalid login - Please try again"
      redirect_to root_path
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_to root_path
  end
end
