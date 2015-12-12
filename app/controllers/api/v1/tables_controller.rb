class API::V1::TablesController < API::APIController

  def show
    respond_with Table.find(params[:id])
  end

end
