class CoursesController < ApplicationController

  before_action :student_logged_in, only: [:select, :quit, :list]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update, :open, :close]#add open by qiao
  before_action :logged_in, only: :index

  #-------------------------for teachers----------------------

  def new
    @course=Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses<<@course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:warning] = "信息填写有误,请重试"
      render 'new'
    end
  end

  def edit
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash={:info => "更新成功"}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to courses_path, flash: flash
  end

  def open
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end

  def close
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  #-------------------------for students----------------------

  def list
    #-------QiaoCode--------
    @courses = Course.where(:open=>true).paginate(page: params[:page], per_page: 4)
    @course = @courses-current_user.courses
    tmp=[]
    @course.each do |course|
      if course.open==true
        tmp<<course
      end
    end
    @course=tmp
  end

  def select
    @course=Course.find_by_id(params[:id])
    if @course.limit_num > @course.student_num
      @course.update_attributes(student_num: @course.student_num + 1)
      current_user.courses<<@course
      flash={:suceess => "成功选择课程: #{@course.name}"}
    else

      flash={:danger => "fail to select: #{@course.name}" }
    end
    redirect_to courses_path, flash: flash
  end

  def quit
    @course=Course.find_by_id(params[:id])
    current_user.courses.delete(@course)
    if @course.student_num > 0
      @course.update_attributes(student_num: @course.student_num - 1)
    end
    flash={:success => "成功退选课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end


  #-------------------------for both teachers and students----------------------

  def index
    @course=current_user.teaching_courses.paginate(page: params[:page], per_page: 4) if teacher_logged_in?
    # @course=current_user.courses.paginate(page: params[:page], per_page: 4) if student_logged_in?
    if student_logged_in?
      credit = 0
      core = 0
      # @course=  current_user.courses
      @course = Course.select("courses.id, name, course_code,course_type,teaching_type,exam_type,credit,limit_num,student_num,class_room,course_time,course_week,grades.is_core,teacher_id").joins(:grades).where("grades.user_id" => session[:user_id])
      @course.each {|c|
        num = c.credit.split('/')[1].to_f
        credit += num
        if c.is_core?
          core += num
        end
      }
      @result = [credit,core]
      @course = @course.paginate(page: params[:page], per_page: 4)
      [@result,@course]
    end
  end

  def search
    keyword = params[:search][:keyword].lstrip.rstrip
    if student_logged_in?
      credit = 0
      core = 0
      attr = "courses.id, name, course_code,course_type,teaching_type,exam_type,credit,limit_num,student_num,class_room,course_time,course_week,grades.is_core,teacher_id"
      @course = Course.select(attr).joins(:grades).where("grades.user_id" => session[:user_id]).where('course_code like ? or name like ?', "%#{keyword}%", "%#{keyword}%")
      @course.each {|c|
        num = c.credit.split('/')[1].to_f
        credit += num
        if c.is_core?
          core += num
        end
      }
      @result = [credit,core]
      [@result,@course]
      render :index
    elsif teacher_logged_in?
      @course=current_user.teaching_courses
      @course = @course.where('course_code like ? or name like ?', "%#{keyword}%", "%#{keyword}%")
      render :index
    else
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def searchlist
    keyword = params[:search][:keyword].lstrip.rstrip
    if student_logged_in?
      @course=Course.where(:open=>true).where('"courses"."course_code" like ? or "courses"."name" like ?',"%#{keyword}%","%#{keyword}%")
      @course=@course-current_user.courses
      @course = @course
      tmp=[]
      @course.each do |course|
        if course.open==true
          tmp<<course
        end
      end
      @course=tmp
      render :list
    else
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end
  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
                                   :credit, :limit_num, :class_room, :course_time, :course_week)
  end


end
