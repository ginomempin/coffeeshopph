require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Test User", email: "user@test.com")
  end

  test "should create valid user" do
    assert @user.valid?
  end

  test "empty name should be invalid" do
    @user.name = nil
    assert_not @user.valid?
    @user.name = ""
    assert_not @user.valid?
    @user.name = "   "
    assert_not @user.valid?
  end

  test "too long names should be invalid" do
    @user.name = ("a" * 51)
    assert_not @user.valid?
  end

  test "empty email should be invalid" do
    @user.email = nil
    assert_not @user.valid?
    @user.email = ""
    assert_not @user.valid?
    @user.email = "   "
    assert_not @user.valid?
  end

  test "too long emails should be invalid" do
    @user.email = ("a" * (256 - "@test.com".length)) + "@test.com"
    assert_not @user.valid?
  end

  test "valid emails should be accepted" do
    addresses = ["user@test.com",
                 "USER@test.com",
                 "user@TEST.com",
                 "user@test.COM",
                 "u_ser@test.com",
                 "us-er@test.com",
                 "user@tes-t.com",
                 "us+er@test.com",
                 "some.user@test.com",
                 "user@test.ph",
                 "user@test.bar.org",
                 "user@bz.co.jp"
                ]
    addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, "#{addr.inspect} should be valid"
    end
  end

  test "invalid emails should not be accepted" do
    addresses = ["user@test,com",
                 "user@t_est.com",
                 "user@test",
                 "user_at_test.com",
                 "@test.com",
                 "user",
                 "user@.com",
                 "user@test..com",
                 "user@",
                 "user@test+test.com",
                 "user@test.another@test.com",
                 "u ser@test.com",
                 "user@tes t.com"
                ]
    addresses.each do |addr|
      @user.email = addr
      assert_not @user.valid?, "#{addr.inspect} should not be valid"
    end
  end

end
