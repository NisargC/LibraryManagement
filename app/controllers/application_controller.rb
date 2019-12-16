class ApplicationController < ActionController::Base
 #checking branch
  before_action :create_auth

  def create_auth
    puts params
    unless (params[:action] == 'login' || params[:action] == 'signup' || params[:action] == 'authorize' || params[:controller] == 'auth')
      if session[:user_id].nil?
      flash[:notice] = 'You are not allowed to do this transaction here. Kindly login first!'
      redirect_to '/auth/login'
    end
      end
  end

end
