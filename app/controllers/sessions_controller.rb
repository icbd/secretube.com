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
    redirect_to dashboard_url
  end

  # DELETE
  # /logout
  def destroy
    logout if current_user
    redirect_to welcome_index_url
  end
end
