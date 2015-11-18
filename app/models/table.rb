class Table < ActiveRecord::Base
  has_many :orders, dependent: :destroy

  after_validation :toggle_occupied

  validates :name, presence:  true,
                   length:    { maximum: 50 }

  validates :max_persons, numericality: { only_integer: true,
                                          greater_than_or_equal_to: 2,
                                          less_than_or_equal_to: 4 }

  validates :num_persons, numericality: { only_integer: true,
                                          greater_than_or_equal_to: 0,
                                          less_than_or_equal_to: :max_persons }

  validates :total_bill, numericality: { greater_than_or_equal_to: 0 }

  #-------------------
  # Private Methods
  #-------------------
  private

    def toggle_occupied
      self.occupied = (self.num_persons > 0 ? true : false)
    end

end
