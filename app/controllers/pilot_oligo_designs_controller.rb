class PilotOligoDesignsController < ApplicationController  
  def show
    @oligo_design = PilotOligoDesign.find(params[:id] )
    render :controller => 'oligo_designs', :action => 'show'
  end
  
end
