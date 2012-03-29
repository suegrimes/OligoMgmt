class UsersController < ApplicationController

  skip_before_filter :login_required, :only => [:new, :create]
  require_role "admin", :for_all_except => [:new, :create]

  # render index.rhtml
  def index
    @users = User.find(:all, :include => :roles)
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
      redirect_to('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  # render edit.html
  def edit 
    @user = User.find(params[:id])
    @roles = Role.find(:all)
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

end
