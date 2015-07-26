module PromosHelper

  def promo_code_generator
    charset = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
    charset.shuffle[0..5].join
  end

end
