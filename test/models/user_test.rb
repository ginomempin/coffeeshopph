require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Test User",
                     email: "user@test.com",
                     password: "123456",
                     password_confirmation: "123456")
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

  test "valid email formats should be accepted" do
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

  test "invalid email formats should not be accepted" do
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

  test "email addresses should be unique" do
    @user.save
    duplicate_user = @user.dup
    assert_not duplicate_user.valid?, "duplicate email address should not be valid"
    duplicate_user.email.upcase!
    assert_not duplicate_user.valid?, "uniqueness should be case-insensitive (uppercase)"
    duplicate_user.email.downcase!
    assert_not duplicate_user.valid?, "uniqueness should be case-insensitive (lowercase)"
  end

  test "email addresses should be saved in lowercase" do
    @user.email = "aBCdeFG@test.com"
    @user.save
    assert_equal(@user.email.downcase, @user.reload.email)
  end

  test "empty passwords should be invalid" do
    @user.password = nil
    @user.password_confirmation = nil
    assert_not @user.valid?
    @user.password = ""
    @user.password_confirmation = ""
    assert_not @user.valid?
    @user.password = "   "
    @user.password_confirmation = "   "
    assert_not @user.valid?
  end

  test "passwords should have a minimum length" do
    @user.password = "123"
    @user.password_confirmation = "123"
    assert_not @user.valid?
  end

  test "authenticated? should return false if password_digest is nil" do
    assert_not @user.authenticated?(:password, 'any_token')
  end

  test "created users should have an auto-generated authentication token" do
    @user.save
    assert_not_nil   @user.authentication_token
    assert_not       @user.authentication_token.empty?
    assert_equal 22, @user.authentication_token.length
  end

  test "should prevent saving of duplicate authentication tokens" do
    @user.save
    another_user = User.new(name: "Another User",
                            email: "another_user@test.com",
                            password: "654321",
                            password_confirmation: "654321",
                            authentication_token: @user.authentication_token)
    assert_not another_user.valid?
  end

end
