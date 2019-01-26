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

  test "login with welcome page" do
    pswd = "password"
    user = create(:user, pswd: pswd)

    get welcome_index_url
    assert_select ".register_btn", I18n.t(:create_account)

    # login
    post sessions_url, params: {user: {email: user.email, password: pswd}}
    get welcome_index_url
    assert_select ".register_btn", I18n.t(:my_account)
  end


  test "view login page" do
    get login_url
    assert_response :success
  end

  test "view signup page" do
    get register_url
    assert_response :success
  end
end
