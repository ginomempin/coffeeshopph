class Order
  attr_accessor :name,
                :served

  def initialize(name = "", served = false)
    @name = name
    @served = served
  end

  def served?
    @served
  end

end
