class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: :new

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to after_login_path, notice: "Conta criada! Bem-vindo, #{@user.username}."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.expect(user: [ :username, :email, :password, :password_confirmation ])
  end
end
