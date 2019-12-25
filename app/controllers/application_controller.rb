class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user, :current_merchant_user, :current_admin_user

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_merchant_user
    current_user && (current_user.merchant_employee? || current_user.merchant_admin?)
  end

  def current_admin_user
    current_user && current_user.admin?
  end

  def require_user
    render file: "/public/404", status: 404 unless current_user
  end

  def require_merchant
    render file: "/public/404", status: 404 unless current_merchant_user
  end

  def require_admin
    render file: "/public/404", status: 404 unless current_admin_user
  end

  def exclude_merchant
    render file: "/public/404", status: 404 if current_merchant_user
  end

  def exclude_admin
    render file: "/public/404", status: 404 if current_admin_user
  end

  def flash_errors(resource)
    flash[:error] = resource.errors.full_messages.to_sentence
  end
end
