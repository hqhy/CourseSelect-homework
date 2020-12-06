class GradesController < ApplicationController

  before_action :teacher_logged_in, only: [:update]

  def update
    @grade=Grade.find_by_id(params[:id])
    if @grade.update_attributes!(:grade => params[:grade][:grade])
      flash={:success => "#{@grade.user.name} #{@grade.course.name}的成绩已成功修改为 #{@grade.grade}"}
    else
      flash={:danger => "上传失败.请重试"}
    end
    redirect_to grades_path(course_id: params[:course_id]), flash: flash
  end

  def index
    #binding.pry
    if teacher_logged_in?
      @course = Course.find_by_id(params[:course_id])
      @grades = @course.grades.order(created_at: "desc").paginate(page: params[:page], per_page: 4)
    elsif student_logged_in?
      @grades=current_user.grades.paginate(page: params[:page], per_page: 4)
    else
      redirect_to root_path, flash: {:warning=>"请先登陆"}
    end
  end

  def close
    @grade = Grade.find_by_id(params[:id])
    @grade.update_attributes(is_core: false)
    @course = Course.find_by_id(@grade.course_id)
    redirect_to grade_path, flash: {:success => "已取消该核心课:#{ @course.name}"}
  end

  def open
    @grade = Grade.find_by_id(params[:id])
    @grade.update_attributes(is_core: true)
    @course = Course.find_by_id(@grade.course_id)
    redirect_to grade_path, flash: {:success => "已设该课为核心课:#{ @course.name}"}
  end

  private

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

end
