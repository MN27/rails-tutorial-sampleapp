require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count:2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    # 10.3.1演習
    assert_select "a[href=?]", users_path, count:0
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign up")
    # 10.3.1演習
    get users_path
    assert_redirected_to login_path
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", users_path
    get users_path
    assert_template 'users/index'
  end
end
