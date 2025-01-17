class SessionsController < ApplicationController
  allow_unauthenticated_access

  def create
    user = User.authenticate_by(email: user_params[:login], password: user_params[:password])

    if user.is_a?(User) && !user.errors.any?
      render json: { access_token: gen_access_token(user), refresh_token: gen_refresh_token(user), message: "Logado com sucesso!" }
    else
      render json: { errors: [ "Login e senha inválidos" ] }, status: :unauthorized
    end
  end

  def refresh
    generate_new_access_token_by_refresh
  end

  private

  def user_params
    params.permit(:login, :password)
  end
end
