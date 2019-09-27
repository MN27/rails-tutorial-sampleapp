require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "should not open non-activated user's show" do
    get signup_path
    post users_path,
         params: {
           user: {
             name: "Non Activation User",
             email: "nau@example.com",
             password: "password",
             password_confirmation: "password"
           }
         }
    non_activation_user = assigns(:user)
    log_in_as(@user)
    get user_path(non_activation_user)
    assert_redirected_to root_url
  end
end
