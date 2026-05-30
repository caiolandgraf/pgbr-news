class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: :new

  def new
  end

  def create
    user = User.find_by(email: params[:email]&.strip&.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to after_login_path, notice: "Bem-vindo de volta, #{user.username}!"
    else
      flash.now[:alert] = "E-mail ou senha incorretos. Tente novamente."
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_path, notice: "Você saiu da sua conta."
  end
end
