require 'test_helper'

class GradesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  def test_index
    get :index
  end

end
