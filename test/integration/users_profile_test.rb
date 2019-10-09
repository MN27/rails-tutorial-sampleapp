require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:michael)
  end
  
  test "profile display with relationships count on the show and home" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    # 14.2.2演習 =>
    assert_select '#following',  text: @user.following.count.to_s
    assert_select '#followers',   text: @user.followers.count.to_s
    # <=
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    # 14.2.2演習 =>
    log_in_as(@user)
    get root_path
    assert_select '#following',  text: @user.following.count.to_s
    assert_select '#followers',   text: @user.followers.count.to_s
    # <=
  end
end
