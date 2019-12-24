class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def flash_errors(resource)
    flash[:error] = resource.errors.full_messages.to_sentence
  end
end
