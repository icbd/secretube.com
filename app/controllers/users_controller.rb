class UsersController < ApplicationController
  # POST
  # /users
  def create
    user = User.new(safe_create_params)
    if user.save
      flash[:success] = I18n.t('welcome_come')
      # TODO: SEND EMAIL
      redirect_to dashboard_url
    else
      flash[:warning] = user.errors.full_messages
      redirect_to price_url
    end
  end

  private

  def safe_create_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
