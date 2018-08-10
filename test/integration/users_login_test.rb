require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:elias)
  end

  test "login with invalid information" do
  	#visit login path
    get login_path
    #Verify that the new sessions form renders properly
    assert_template 'sessions/new'
    #Post to the sessions path with an invalid params hash.
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    #Verify that the new sessions form gets re-rendered and that a flash message appears.
    assert_not flash.empty?
    #Visit another page (such as the Home page).
    get root_path
    #Verify that the flash message doesn’t appear on the new page.
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end