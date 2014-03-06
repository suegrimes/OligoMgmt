class PilotOligoDesignsController < ApplicationController
  load_and_authorize_resource

  def show
    @oligo_design = PilotOligoDesign.find(params[:id] )
    render :controller => 'oligo_designs', :action => 'show'
  end
  
end
