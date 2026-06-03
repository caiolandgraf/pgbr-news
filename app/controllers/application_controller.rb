class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  inertia_share do
    {
      currentUser: current_user.as_json(only: [ :id, :name, :username, :email ]),
      flash: {
        notice: flash[:notice],
        alert: flash[:alert]
      }
    }
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    session[:return_to] = request.fullpath if request.get? || request.head?
    redirect_to login_path, alert: "Faça login para continuar."
  end

  def redirect_if_logged_in
    redirect_to after_login_path, notice: "Você já está conectado." if logged_in?
  end

  def after_login_path
    session.delete(:return_to) || root_path
  end
end
