class VectorsController < ApplicationController
    require_role "stanford"
    require_role "admin", :for => [:new, :create, :destroy]
  
  # GET /vectors
  def index
    @vectors = Vector.find(:all)
  end

  # GET /vectors/1
  def show
    @vector = Vector.find(params[:id])
  end

  # GET /vectors/new
  def new
    @vector = Vector.new
  end

  # GET /vectors/1/edit
  def edit
    @vector = Vector.find(params[:id])
  end

  # POST /vectors
  def create
    @vector = Vector.new(params[:vector])

    if @vector.save
      flash[:notice] = 'Vector was successfully created.'
      redirect_to(@vector)
    else
      render :action => "new" 
    end
   end

  # PUT /vectors/1
  def update
    @vector = Vector.find(params[:id])

    if @vector.update_attributes(params[:vector])
      flash[:notice] = 'Vector was successfully updated.'
      redirect_to(@vector) 
    else
      render :action => "edit" 
    end
  end

  # DELETE /vectors/1
  def destroy
    @vector = Vector.find(params[:id])
    @vector.destroy

    redirect_to(vectors_url)
  end

end
