class ProfilesController < ApplicationController
  before_action :set_user
  before_action :require_owner, only: %i[ edit update ]

  def show
    @articles = @user.articles.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to profile_path(@user), notice: "Perfil atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username].to_s.downcase)
  end

  def require_owner
    return if logged_in? && current_user == @user

    redirect_to profile_path(@user), alert: "Você só pode editar o seu próprio perfil."
  end

  def profile_params
    params.expect(user: [ :name, :username, :bio ])
  end
end
