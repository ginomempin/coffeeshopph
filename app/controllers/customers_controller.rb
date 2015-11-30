class CustomersController < ApplicationController
  before_action :require_logged_in_user, only: [:create, :destroy]

  def create
    server = User.find(params[:server_id])
    table = Table.find(params[:table_id])

    if table
      # increment the num_persons field of table to set it as occupied
      # TODO: num_persons should be provided from the UI
      # TODO: encapsulate the update in a Table#occupy method
      table.update_attributes({num_persons: 1})
      
      if server.serve(table)
        flash[:success] = "Table is now occupied."
      else
        flash[:danger] = "Unable to assign server to table."
      end
    else
      flash[:danger] = "Unable to update the table attributes."
    end

    redirect_to table_path(table.id)
  end

  def destroy
    customer = Customer.find(params[:id])
    server = User.find(customer.server_id)
    table = Table.find(customer.table_id)

    if table
      # zero the num_persons field and the total bill of the table to set it as free
      # also, delete the table's orders
      # TODO: encapsulate the update in a Table#clear method
      table.clear_orders
      table.update_attributes({num_persons: 0, total_bill: 0})

      if server.clear(table)
        flash[:success] = "Table is now cleared."
      else
        flash[:danger] = "Unable to clear table."
      end
    else
      flash[:danger] = "Unable to update the table attributes."
    end

    redirect_to table_path(table.id)
  end

end
