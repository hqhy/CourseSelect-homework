require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @course = Course.new(name: "Example Course", course_type: "Example Type", teaching_type: "Online", exam_type: "Offline", limit_num: 0, credit: 1, class_room: "222", course_week: "1", course_time: "1h")
  end

  test "should be valid" do
    assert @course.valid?
  end

  test "name should be present" do
    @course.name = "     "
    assert_not @course.valid?
  end

  test "name should not be too long" do
    @course.name = "a" * 51
    assert_not @course.valid?
  end

  test "course_type should be present" do
    @course.course_type = "     "
    assert_not @course.valid?
  end

  test "course_time should be present" do
    @course.course_time = "     "
    assert_not @course.valid?
  end

  test "course_week should be present" do
    @course.course_week = "     "
    assert_not @course.valid?
  end

  test "class_room should be present" do
    @course.class_room = "     "
    assert_not @course.valid?
  end

  test "teaching_type should be present" do
    @course.teaching_type = "     "
    assert_not @course.valid?
  end

  test "exam_type should be present" do
    @course.exam_type = "     "
    assert_not @course.valid?
  end

  test "credit should be present" do
    @course.credit = "     "
    assert_not @course.valid?
  end
end
