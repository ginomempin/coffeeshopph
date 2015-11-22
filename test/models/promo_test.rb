require 'test_helper'

class PromoTest < ActiveSupport::TestCase

  test "specifying name only is valid" do
    promo = Promo.new(name: "Anniversary Sale")
    assert_equal "Anniversary Sale", promo.name
    assert_not promo.code.nil?
    assert_not promo.code.empty?
    assert (promo.code.length == 6)
    assert promo.valid?
  end

  test "specifying both name and code is valid" do
    promo = Promo.new(name: "Anniversary Sale", code: "123456")
    assert_equal "Anniversary Sale", promo.name
    assert_equal "123456", promo.code
    assert promo.valid?
  end

  test "specifying nothing is invalid" do
    promo = Promo.new
    assert_nil promo.name
    assert (promo.code.length == 6)
    assert_not promo.valid?
  end

  test "specifying code only is invalid" do
    promo = Promo.new(code: "123456")
    assert_nil promo.name
    assert_equal "123456", promo.code
    assert_not promo.valid?
  end

  test "too long names are invalid" do
    promo = Promo.new(name: ("a" * 101))
    assert_not promo.valid?
  end

  test "wrong code lengths are invalid" do
    promo = Promo.new(name: "Anniversary Sale")
    promo.code = "12345"
    assert_not promo.valid?
    promo.code = "1234567"
    assert_not promo.valid?
  end

  test "generated codes should be unique" do
    promo1 = Promo.new
    promo2 = Promo.new
    promo3 = Promo.new
    assert_not_equal promo1.code, promo2.code
    assert_not_equal promo1.code, promo3.code
    assert_not_equal promo2.code, promo3.code
  end

  test "allow saving an existing name" do
    promo1 = Promo.new(name: "Anniversary Sale")
    assert promo1.valid?
    assert promo1.save
    promo2 = Promo.new(name: "Anniversary Sale")
    assert promo2.valid?
    assert promo2.save
  end

  test "block saving an existing code" do
    promo1 = Promo.new(name: "Anniversary Sale",
                       code: "123456")
    assert promo1.valid?
    assert promo1.save
    promo2 = Promo.new(name: "Holiday Sale",
                       code: "123456")
    assert_not promo2.valid?
    assert_not promo2.save
  end

  test "generate code only during creation" do
    promo_new = Promo.new(name: "Anniversary Sale")
    assert promo_new.save
    promo_find = Promo.find_by(name: promo_new.name)
    assert_not promo_find.nil?
    assert_equal promo_new.code, promo_find.code
    promo_find = Promo.find_by(code: promo_new.code)
    assert_not promo_find.nil?
    assert_equal promo_new.name, promo_find.name
  end

end
