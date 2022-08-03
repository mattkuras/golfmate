class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  def create
    @user = User.authenticate_by(email: params[:user][:email].downcase, password: params[:user][:password])
    if @user
      if @user.unconfirmed?
        # redirect_to new_confirmation_path, alert: "Incorrect email or password."
        # redirect_to after_login_path, notice: "Signed in."
        redirect_to root_path
      else
        after_login_path = session[:user_return_to] || root_path
        active_session = login @user
        remember(active_session) if params[:user][:remember_me] == "1"
        redirect_to after_login_path, notice: "Signed in."
      end
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget_active_session
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end
end
