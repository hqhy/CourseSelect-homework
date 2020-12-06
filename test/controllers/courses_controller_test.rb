require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  def test_new
    get :new
  end

  def test_list
    get :list
  end

  def test_create
    get :create
  end

  def test_index
    get :index
  end

end
