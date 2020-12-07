# CourseSelect

### [中文教程1](http://blog.csdn.net/ppp8300885/article/details/52594839) [中文教程2](http://blog.csdn.net/ppp8300885/article/details/52601560) [中文教程3](http://blog.csdn.net/ppp8300885/article/details/52669749) [Wiki](https://github.com/PENGZhaoqing/CourseSelect/wiki)


这个样本系统是基于国科大研究生课程 (高级软件工程) 开发的项目,目的是帮助入门者学习RoR (Ruby on Rails),

适合新学者的入手的第一个项目 ([演示Demo戳这里](https://courseselect.herokuapp.com/ ))，入门者可以在这个样本系统上增加更多的功能:

* ~~处理选课冲突、控制选课人数~~
* ~~统计选课学分，学位课等~~
* ~~增加选课的开放、关闭功能~~
* 自定义管理员后台
* 基于OAuth的授权登陆
* Excel格式的数据导入
* 绑定用户邮箱（实现注册激活，忘记密码等）
* 站内查找检索 （课程按分类查找，过滤等）

### 目前功能：

* 多角色登陆（学生，老师，管理员）
* 学生动态选课，退课
* 老师动态增加，删除课程
* 老师对课程下的学生添加、修改成绩
* 权限控制：老师和学生只能看到自己相关课程信息
* 处理选课冲突、控制选课人数**（new）**
* 统计选课学分，学位课等**（new）**
* 增加选课的开放、关闭功能**（new）**

**如果觉得好，给项目点颗星吧～**

### 截图

<img src="/lib/screenshot1.png" width="700">  

<img src="/lib/screenshot2.png" width="700">

<img src="/lib/screenshot3.png" width="700">   

<img src="/lib/screenshot4.png" width="700">

## 说明

目前使用的库和数据库：

* 使用[Bootstrap](http://getbootstrap.com/)作为前端库
* 使用[Rails_admin Gem](https://github.com/sferik/rails_admin)作为后台管理
* 使用[Postgresql](http://postgresapp.com/)作为数据库

使用前需要安装Bundler，Ruby等依赖环境。

请根据本地系统下载安装[postgresql](https://devcenter.heroku.com/articles/heroku-postgresql#local-setup)数据库，并运行`psql -h localhost`检查安装情况。


## 安装

首先请确保本项目的所有依赖（postgresql、ruby-bundler还有一些必要的编译依赖）均已安装，如果您正在使用ubuntu 20.04，可以以管理员身份运行下面的命令

```bash
apt update
apt upgrade -y
apt install -y postgresql ruby-bundler ruby-dev build-essential libpq-dev zlib1g-dev nodejs ruby-railties
service postgresql start
```

另外，请确保当前用户拥有访问postgresql中`courseselect_development`和`courseselect_test`数据库的权限，如果您正在使用ubuntu 20.04，可以使用下面的命令配置数据库

```bash
sudo -u postgres createuser -s "$(whoami)" # 赋予当前用户访问数据库的权限
sudo -u postgres psql -c 'create database courseselect_development;' # 创建courseselect_development数据库
sudo -u postgres psql -c 'create database courseselect_test;' # 创建courseselect_test数据库
```

接下来克隆本项目并配置ruby虚拟环境

```bash
git clone --depth=1 https://github.com/hksdpc250/CourseSelect-homework.git
cd CourseSelect-homework
bundle config set path 'vendor/bundle'
bundle install # 如果这一步失败，可能是由于bundler版本不匹配，删除Gemfile.lock再重试一般可以解决该问题
```

初始化数据库并运行服务器

```bash
rake db:migrate
rake db:seed
rails server
```

在浏览器中输入`localhost:3000`访问主页

## 使用

1.学生登陆：

账号：`student1@test.com`

密码：`password`

2.老师登陆：

账号：`teacher1@test.com`

密码：`password`


3.管理员登陆：

账号：`admin@test.com`

密码：`password`

账号中数字都可以替换成2,3...等等


## Heroku云部署

项目可直接在Heroku上免费部署

1.fork此项目到自己Github账号下

2.创建Heroku账号以及Heroku app

3.将Heroku app与自己Github下的fork的项目进行连接

4.下载配置[Heroku CLI](https://devcenter.heroku.com/articles/heroku-command-line)命令行工具

5.运行`heroku login`在终端登陆，检查与heroku app的远程连接情况`git config --list | grep heroku`，若未检查到相应的app，请看[这里](http://stackoverflow.com/questions/5129598/how-to-link-a-folder-with-an-existing-heroku-app)

6.运行部署，详情[请戳这里](https://devcenter.heroku.com/articles/getting-started-with-rails4#rails-asset-pipeline)


## 本地测试

本项目包含了部分的测试（integration/fixture/model test），测试文件位于/test目录下。一键运行所有测试使用`rake test`：

```
sctest@DESKTOP-IM0BR13:~/CourseSelect$ rake test 2> /dev/null
Run options: --seed 11062

# Running:

............................

Finished in 3.298965s, 8.4875 runs/s, 9.0938 assertions/s.
28 runs, 30 assertions, 0 failures, 0 errors, 0 skips
Coverage report generated for Minitest to /home/sctest/CourseSelect/coverage. 122 / 242 LOC (50.41%) covered.
```

### 模型测试

以用户模型为例, 位于`test/models/user_test.rb`, 首先生成一个`@user`对象，然后`assert`用户是否有效，这里的调用`valid`方法会去检查你的模型中的相关的`validates`语句是否正确，若`@user.valid?`为false, 那么此`assert`会报错，代表`"should be valid"`这条测试没有通过, 单独运行此测试文件使用`rake test test/models/user_test.rb`


```
class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert  @user.valid?
  end

  ...

end
```

### 视图和控制器测试

以用户登录为例，位于`test/integration/user_login_test.rb`，首先同样生成一个@user模型，这个@user的用户名和密码可以在`test/fixtures/users.yml`中指定, 然后我们用get方法到达登录页面（sessions_login_path），然后使用post方法提交这个@user的账号密码来登录，如果登录成功，当前应该会跳转至homes控制器下的index方法进行处理，`assert_redirected_to`能判断这个跳转过程是否发生，然后调用`follow_redirect！`来紧跟当前的跳转，用`assert_template`来判读跳转后的视图文件是否为`homes/index`, 最后在这个视图文件下做一些测试，比如判断这个视图下连接为root_path的个数等等（根据当前登录的角色不同，当前的页面链接会不同，比如admin用户就会有控制面板的链接rails_admin_path，而普通用户没有，因此可以根据链接的个数来判断当前登录用户的角色）

```
class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:peng)
  end

  test "login with valid information" do
    get sessions_login_path
    post sessions_login_path(params: {session: {email: @user.email, password: 'password'}})
    assert_redirected_to controller: :homes, action: :index
    follow_redirect!
    assert_template 'homes/index'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", rails_admin_path, count: 0
  end
end
```

### 测试涵盖率检测

我们可以使用[simplecov](https://github.com/colszowka/simplecov/)库来检测我们编写的测试对于我们的项目是否完整，步骤如下：

1. 在Gemfile文件中导入simplecov库：`gem 'simplecov', :require => false, :group => :test`，然后`bundle install`安装
2. 在test/test_helper.rb的最前面加入simplecov的启动代码（这里默认使用rails自带的test框架，simplecov也支持其他测试框架如rspec，那么启动代码导入的位置请参考simplecov的官方文档）

  ```
  # 注意这里必须在 require rails/test_help 之前加入，否则不会生效
  require 'simplecov'
  SimpleCov.start 'rails'

  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

  class ActiveSupport::TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
  ```

3. 运行`rake test`,成功后会根目录的coverage下生成一个index.html文件。


## Github Actions 线上自动测试

上述为本地测试，我们可以使用Github Actions来实现自动测试，相关代码位于`.github/workflows/test.yml`，由于是GitHub内置的功能，无需过多配置即可自动应用，每次在master分支提交修改均会自动测试。

## How to Contribute

先fork此项目，在分支修改后，pull request到主分支

提问请到issues里创建，欢迎contributor！


