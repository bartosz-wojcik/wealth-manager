require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  # login page
  test 'should get login_page' do
    get :new
    assert_response :success
    assert_not_nil assigns(:account)
  end

  test 'should login' do
    user = accounts(:user)
    post :create, :email => user.email, :password => user.password
    assert_redirected_to root_path
    assert_not_nil flash[:success]
  end

  test 'should not login 1' do
    post :create, :email => 'user@example.com', :password => 'invalid'
    assert_redirected_to login_path
    assert_not_nil flash[:danger]
  end

  test 'should not login 2' do
    post :create, :email => 'invalid@example.com', :password => 'invalid'
    assert_redirected_to login_path
    assert_not_nil flash[:danger]
  end

  # logout
  test 'should logout' do
    get :destroy
    assert_redirected_to login_url
    assert_not_nil flash[:success]
  end

  test 'should_get_activate_start' do
    get :activate_start
    assert_response :success
  end

end
