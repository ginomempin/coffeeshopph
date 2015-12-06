class Api::V1::TablesController < ApplicationController
  respond_to :json

  def show
    respond_with Table.find(params[:id])
  end

end
