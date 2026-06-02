require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get login page" do
    get login_url
    assert_response :success
  end

  test "should log in using email" do
    post login_url, params: { login: @user.email, password: "password" }
    assert_redirected_to root_url
    assert_equal @user.id, session[:user_id]
  end

  test "should log in using username" do
    post login_url, params: { login: @user.username, password: "password" }
    assert_redirected_to root_url
    assert_equal @user.id, session[:user_id]
  end

  test "should not log in with invalid credentials" do
    post login_url, params: { login: "nonexistent", password: "wrong_password" }
    assert_response :unprocessable_content
    assert_nil session[:user_id]
  end

  test "should not log in with incorrect password" do
    post login_url, params: { login: @user.email, password: "wrong_password" }
    assert_response :unprocessable_content
    assert_nil session[:user_id]
  end

  test "should log out" do
    post login_url, params: { login: @user.email, password: "password" }
    assert_equal @user.id, session[:user_id]

    delete logout_url
    assert_redirected_to root_url
    assert_nil session[:user_id]
  end
end
