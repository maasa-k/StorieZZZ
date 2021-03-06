class SessionsController < ApplicationController
  def home
    if logged_in?
      render '/users/show'
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id 
      redirect_to user_path(@user)
    else
      redirect_to login_path
    end
  end

  def google
    @user = User.find_or_create_by(email: auth[:info][:email]) do |user|
      user.username = auth[:info][:name]
      user.password = SecureRandom.hex
    end
    if @user
      session[:user_id] = @user.id 
      redirect_to user_path(@user)
    else
      redirect_to '/'
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
