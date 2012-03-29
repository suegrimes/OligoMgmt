class VersionsController < ApplicationController
    require_role "stanford"
    require_role "admin", :for => [:new, :create, :destroy]
  
  # GET /versions
  def index
    @versions = Version.find(:all)
  end

  # GET /versions/1
  def show
    @version = Version.find(params[:id])
  end

  # GET /versions/new
  def new
    @version = Version.new
  end

  # GET /versions/1/edit
  def edit
    @version = Version.find(params[:id])
  end

  # POST /versions
  def create
    @version = Version.new(params[:version])

    if @version.save
      flash[:notice] = 'Version was successfully created.'
      redirect_to(@version)
    else
      render :action => "new" 
    end
   end

  # PUT /versions/1
  def update
    @version = Version.find(params[:id])

    if @version.update_attributes(params[:version])
      flash[:notice] = 'Version was successfully updated.'
      redirect_to(@version) 
    else
      render :action => "edit" 
    end
  end

  # DELETE /versions/1
  def destroy
    @version = Version.find(params[:id])
    @version.destroy

    redirect_to(versions_url)
  end
end
