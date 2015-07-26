class Table
  attr_accessor :persons,
                :orders

  # Sets-up a table with the following info:
  #  persons  : number of persons
  #  orders   : array containing the table's orders
  def initialize(persons = 0, orders = Array.new)
    @persons = persons
    @orders = orders
  end

  # Returns the number of orders waiting to be served
  def check_waiting_orders
    waiting = 0
    @orders.each do |order|
      if !order.served?
        waiting += 1
      end
    end
    return waiting
  end

  def info
    "#{@persons} person/s, waiting for #{check_waiting_orders} order/s"
  end

end
