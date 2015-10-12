# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first

    # The user token is only generated when creating
    # a new user. Since we are faking the preview by
    # using an existing user, the token has to be
    # forcibly set.
    user.activation_token = User.token

    UserMailer.account_activation(user)
  end

end
