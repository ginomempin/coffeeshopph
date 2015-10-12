require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:admin1)
    user.activation_token = User.token
    mail = UserMailer.account_activation(user)
    assert_equal "[CoffeeShopPH] Account Activation", mail.subject
    assert_equal [user.email],                        mail.to
    assert_equal ["noreply@coffeeshopph.com"],        mail.from
    assert_match user.name,                           mail.body.encoded
    assert_match user.activation_token,               mail.body.encoded
    assert_match CGI::escape(user.email),             mail.body.encoded
  end

end
