class UsersController < ApplicationController
  # POST
  # /users
  def create
    user = User.new(safe_params)
    if user.save
      flash[:success] = I18n.t('welcome_come')
      # TODO: SEND EMAIL
      redirect_to '/' # TODO: dashboard_url
    else
      flash[:warning] = user.errors.full_messages
      redirect_to register_url
    end
    # binding.pry
  end

  private

  def safe_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
