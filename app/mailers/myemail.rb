class Myemail < ApplicationMailer

  def send_mail(to)
    @user = User.find_by(email: to)
    if @user == nil?
      redirect_to root_url , flash:{ danger: "账号信息填写有误"}
    end
    @code = generate_code(to,6)
    title = "Verify your email : "
    mail(
        :subject => title,
        :to => to,
        :from => "nwu_hq@163.com",
        :date => Time.now,
    )
  end

  def generate_code(to,len)
    code = ""
    @user = User.find_by(email: to.downcase)
    1.upto(len){ |i| code << rand(10).to_s }
    @user.update_attributes(verify_code: code)
    code
  end
end
