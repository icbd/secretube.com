require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "login by email & password" do
    correct_pswd = "correct_pswd"
    wrong_pswd = "wrong_pswd"

    user = create(:user, pswd: correct_pswd)

    post sessions_url, params: {user: {email: user.email, password: wrong_pswd}}

    follow_redirect!
    assert_response :success

  end
end
