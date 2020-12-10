class SessionsController < ApplicationController
  include SessionsHelper

  def create
    user = User.find_by(email: login_params[:email].downcase)
    if user && user.authenticate(login_params[:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember_user(user) : forget_user(user)
      flash= {:info => "欢迎回来: #{user.name} :)"}
    else
      flash= {:danger => '账号或密码错误'}
    end
    redirect_to root_url, :flash => flash
  end

  def new

  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def bind_email

  end

  def check_email
    @user = User.find_by_email(params[:session][:email])
    if @user && @user.verify_code.eql?(params[:session][:code])
      if @user.update_attributes(active: true)
        flash={:info => "绑定成功"}
      else
        flash={:warning => "绑定失败"}
      end
      redirect_to sessions_login_url, :flash => flash
    else
      redirect_to sessions_bind_email_url, flash: {danger: "邮箱或验证码错误"}
    end
  end

  def forget_password
    email = params[:session][:email]
    if email =~ URI::MailTo::EMAIL_REGEXP
      Myemail.send_mail(params[:session][:email]).deliver_now
    else
      redirect_to sessions_forget_url, flash: {danger:  "没有输入正确邮箱"}
    end
  end

  def forget

  end

  def check_login
    @user = User.find_by_email(params[:session][:email])
    if @user.verify_code.eql?(params[:session][:code])
      if params[:session][:password] == params[:session][:password_confirmation]
        if @user.update_attributes(user_params) && @user.update_attributes(verify_code: "complete")
          flash={:info => "更新成功"}
        else
          flash={:warning => "更新失败"}
        end
        redirect_to root_path, flash: flash
      else
        redirect_to sessions_forget_path, flash: {danger: "密码不一致"}
      end
    else
      redirect_to sessions_forget_url, flash: {danger:  "验证失败"}
    end
  end

  private
  def user_params
    params.require(:session).permit(:email, :password, :password_confirmation)
  end


  private
  def login_params
    params.require(:session).permit(:email, :password)
  end
end
