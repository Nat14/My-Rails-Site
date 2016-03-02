require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test "should get play_magic8" do
    get :play_magic8
    assert_response :success
  end

end
