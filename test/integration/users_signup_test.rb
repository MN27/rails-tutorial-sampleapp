require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, 
           params: {
             user: { 
               name: "",
               email: "user@invalid",
               password: "foo",
               password_confirmation: "bar"
             }
           }
    end
    assert_template 'users/new'
    assert_select "form[action=?]", "/signup"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path,
           params: {
             user: {
               name: "Example User",
               email: "user@example.com",
               password: "password",
               password_confirmation: "password"
             }
           }
    end
    follow_redirect!
    assert_template 'users/show'
    # 8.2.5以前のテスト
     # assert_not flash.nil?
     # assert_select "div.alert-success"
    # include SessionsHelperの場合
     # assert logged_in?
    assert is_logged_in?
  end
end
