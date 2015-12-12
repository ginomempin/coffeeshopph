class API::V1::TablesController < API::APIController
  respond_to :json

  def show
    respond_with Table.find(params[:id])
  end

end
