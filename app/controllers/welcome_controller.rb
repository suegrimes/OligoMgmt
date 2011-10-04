class WelcomeController < ApplicationController
  skip_before_filter :login_required
  
  def index
    if logged_in?
      render :action => 'index'
    else
      render :action => 'login'
    end
  end

  def user_login
    self.current_user = User.authenticate(params[:login], params[:password])
    # Authorization::current_user = @user   # for declarative_authorization #
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      render :action => 'index'
    else
      @invalid_login_flag = 1;
      flash.now[:error] = "Invalid login - please try again"
      render :action => 'login'
    end
  end

  def signup
    @user = User.new(params[:user])
    render :action => 'signup'
  end
  
  def add_user
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    flash.now[:notice] = "Thanks for signing up!"
    render :action => 'index'
    
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash.now[:notice] = "You have been logged out."
    render :action => 'login'
  end
  
 
end