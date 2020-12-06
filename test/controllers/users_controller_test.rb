require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  #def test_create
  #  get :create
  #end

  def test_new
    get :new
  end

end
