ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # To prevent conflict with application methods, all test_helper methods
  # should be prepended by 'check_' (note that 'test_' cannot be used here
  # since Rails automatically names all test cases with 'test_').

  # Returns true if a user is logged-in, false otherwise.
  def check_logged_in?
    !session[:user_id].nil?
  end

  # Logs in as a test user.
  def check_log_in_as(user, options = {})
    password    = options[:password]    || "password"
    remember_me = options[:remember_me] || '1'
    if check_integration_test?
      post login_path, session: { email: user.email,
                                  password: password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  def check_log_out
    if check_integration_test?
      delete logout_path
    else
      session.delete(:user_id)
    end
  end

  private

    # Returns true if called inside an integration test.
    # This method checks if the current test can call the
    #  'post_via_redirect' method, which is only available
    #  for integration tests.
    def check_integration_test?
      defined?(post_via_redirect)
    end

end
