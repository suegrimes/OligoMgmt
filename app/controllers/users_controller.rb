class UsersController < ApplicationController

  skip_before_filter :login_required, :only => [:new, :create, :forgot, :reset]
  require_role "admin", :for_all_except => [:new, :create, :forgot, :reset]

  # render index.rhtml
  def index
    @users = User.includes(:roles).all
  end

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
    if @user.errors.empty?
      @user.roles = Role.find_all_by_name(Role::DEFAULT_ROLE) if Role::DEFAULT_ROLE
	    @user.save
      self.current_user = @user
      flash.now[:notice] = "Thanks for signing up!"
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  # render edit.html
  def edit 
    @user = User.find(params[:id])
    @roles = Role.all
  end
  
  def update
    params[:user][:role_ids] ||= []
 
    @user = User.find(params[:id])
    @user.roles = Role.find(params[:user][:role_ids])

    if @user.update_attributes(params[:user])
      flash[:notice] = "User has been updated"
      redirect_to users_url
    else
      flash[:notice] = "Error updating user"
      render :action => 'edit'
    end
  end
  
  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(users_url) 
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
