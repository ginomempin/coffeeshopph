class Promo < ActiveRecord::Base

  after_initialize :generate_promo_code, if: :is_missing_code?

  validates :name, presence:  true,
                   length:    { maximum: 100 }

  validates :code, presence:  true,
                   length:    { is: 6 },
                   uniqueness: true

  #-------------------
  # Private Methods
  #-------------------

  private

    def is_missing_code?
      self.code.nil? || self.code.empty?
    end

    def generate_promo_code
      charset = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
      self.code = charset.shuffle[0..5].join
    end

end
