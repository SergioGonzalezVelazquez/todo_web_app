require 'test_helper'

class Admin::ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_application_index_url
    assert_response :success
  end

end
