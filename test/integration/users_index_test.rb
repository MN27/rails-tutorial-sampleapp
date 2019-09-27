require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @user = users(:lana)
  end
  
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count:2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "delete"
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: "delete", count: 0
  end
  
  test "should not display non-activated users on index" do
    users = User.all
    users.each_with_index do |user, index|
      if index % 2 == 0
        user.update_columns(activated: false, activated_at: nil)
      end
    end
    log_in_as(@user)
    get users_path
    users.each do |user|
      if user.activated
        assert_select "a[href=?]", user_path(user), text: user.name
      else
        assert_select "a[href=?]", user_path(user), text: user.name, count: 0
      end
    end
  end
  
end
