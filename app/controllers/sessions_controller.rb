class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: :new

  def new
    render inertia: "Sessions/New"
  end

  def create
    login_input = (params[:login] || params[:email])&.strip&.downcase
    user = User.find_by(email: login_input) || User.find_by(username: login_input)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to after_login_path, notice: "Bem-vindo de volta, #{user.username}!"
    else
      render inertia: "Sessions/New", props: {
        login: params[:login] || params[:email],
        errors: ["E-mail, usuário ou senha incorretos. Tente novamente."]
      }, status: :unprocessable_content
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_path, notice: "Você saiu da sua conta."
  end
end
