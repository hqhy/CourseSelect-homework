require 'test_helper'

class HomesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  def test_index
    get :index
  end

end
