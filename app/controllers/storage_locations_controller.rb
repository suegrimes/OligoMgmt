class StorageLocationsController < ApplicationController
  require_role "stanford"
  
  # GET /storage_locations
  # GET /storage_locations.xml
  def index
    @storage_locations = StorageLocation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @storage_locations }
    end
  end

  # GET /storage_locations/1
  # GET /storage_locations/1.xml
  def show
    @storage_location = StorageLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @storage_location }
    end
  end

  # GET /storage_locations/new
  # GET /storage_locations/new.xml
  def new
    @storage_location = StorageLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @storage_location }
    end
  end

  # GET /storage_locations/1/edit
  def edit
    @storage_location = StorageLocation.find(params[:id])
  end

  # POST /storage_locations
  # POST /storage_locations.xml
  def create
    @storage_location = StorageLocation.new(params[:storage_location])

    respond_to do |format|
      if @storage_location.save
        flash[:notice] = 'StorageLocation was successfully created.'
        format.html { redirect_to(@storage_location) }
        format.xml  { render :xml => @storage_location, :status => :created, :location => @storage_location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @storage_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /storage_locations/1
  # PUT /storage_locations/1.xml
  def update
    @storage_location = StorageLocation.find(params[:id])

    respond_to do |format|
      if @storage_location.update_attributes(params[:storage_location])
        flash[:notice] = 'StorageLocation was successfully updated.'
        format.html { redirect_to(@storage_location) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @storage_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /storage_locations/1
  # DELETE /storage_locations/1.xml
  def destroy
    @storage_location = StorageLocation.find(params[:id])
    @storage_location.destroy

    respond_to do |format|
      format.html { redirect_to(storage_locations_url) }
      format.xml  { head :ok }
    end
  end
end
