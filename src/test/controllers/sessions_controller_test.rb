require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # login page
  test 'should get login_page' do
    get '/login'
    assert_response :success
    assert_includes @response.body, 'E-mail'
    assert_includes @response.body, 'Password'
  end

  # test 'should login' do
  #   user = accounts(:user)
  #   post '/login', params: { email: user.email, password: user.password }
  #   assert_redirected_to root_path
  #   assert_not_nil flash[:success]
  # end

  # test 'should not login 1' do
  #   post '/login', params: { email: 'user@example.com', password: 'invalid' }
  #   assert_redirected_to login_path
  #   assert_not_nil flash[:danger]
  # end

  test 'should not login 2' do
    post '/login', params: { email: 'invalid@example.com', password: 'invalid' }
    assert_redirected_to login_path
    assert_not_nil flash[:danger]
  end

  # logout
  test 'should logout' do
    get '/logout'
    assert_redirected_to login_url
    assert_not_nil flash[:success]
  end

  test 'should_get_activate_start' do
    get '/activate'
    assert_response :success
  end

end
