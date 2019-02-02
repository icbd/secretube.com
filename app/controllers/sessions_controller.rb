class SessionsController < ApplicationController
  def index
    redirect_to login_url
  end

  # GET
  # /login
  def show
    @user = User.new
  end

  # GET
  # /register
  def register
    @user = User.new
  end

  def forgot
    # TODO
    @user = User.new
  end

  # POST
  # /sessions
  def create
    @user = User.find_by(email: params[:user][:email])

    unless @user
      flash[:warning] = t('account_not_exist')
      redirect_to(login_url) && return
    end

    unless @user.authenticate(params[:user][:password])
      flash[:warning] = t('wrong_password')
      redirect_to(login_url) && return
    end

    login @user
    redirect_to forgot_sessions_url
  end

  private

  def safe_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
