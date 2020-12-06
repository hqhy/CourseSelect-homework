require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  #def test_create
  #  post :create
  #end

  def test_new
    get :new
  end

  def test_destroy
    get :destroy
  end

end
