class UsersController < ApplicationController

  skip_before_filter :login_required

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      # DEFAULT_ROLE set in role.rb
      @user.roles = Role.find_all_by_name(Role::DEFAULT_ROLE) if Role::DEFAULT_ROLE
      self.current_user = @user
      redirect_to root_url
      flash.now[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  def forgot
    if request.post?
      user = User.find_by_email(params[:user][:email])
      if user
        user.create_reset_code
        flash.now[:notice] = "Reset code sent to #{user.email}"
        render :action => :display_message
      else
        flash[:error] = "#{params[:user][:email]} does not exist in system"
        render :action => :forgot
      end
    
    end
  end
  
  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        @user.delete_reset_code
        flash[:notice] = "Password reset successfully for #{@user.email} - You are now logged in"
        redirect_to root_url
      else
        render :action => :reset
      end
    end
  end

end
