require 'test_helper'

class Constraints::ApiTest < ActionController::TestCase

  def setup
    @base_accept_header = 'application/vnd.coffeeshopph'
    @api_v1 = Constraints::Api.new(version: 1)
    @api_v2 = Constraints::Api.new(version: 2, default: true)
  end

  test "should match when header has correct version" do
    @request.headers['Accept'] = "#{@base_accept_header}.v1"
    assert @api_v1.matches?(@request)
    @request.headers['Accept'] = "#{@base_accept_header}.v2"
    assert_not @api_v1.matches?(@request)
  end

  test "should ignore version when 'default' is specified" do
    @request.headers['Accept'] = "#{@base_accept_header}.v1"
    assert @api_v2.matches?(@request)
    @request.headers['Accept'] = @base_accept_header
    assert @api_v2.matches?(@request)
    @request.headers['Accept'] = ''
    assert @api_v2.matches?(@request)
  end

end
