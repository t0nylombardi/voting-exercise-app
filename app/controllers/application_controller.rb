# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end
end
