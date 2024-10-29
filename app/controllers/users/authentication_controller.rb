class Users::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:valid_token]
  
  def valid_token
    begin
      payload = Google::Auth::IDTokens.verify_oidc(request.headers['HTTP_AUTHORIZATION_TOKEN'], aud: ENV["GOOGLE_OAUTH_CLIENT_ID"])
      @current_user = User.from_google_payload(payload)
      if @current_user
        token = encode_token(user_id: @current_user.id)
        render json: @current_user, serializer: UserSerializer, status: :ok
      else
        render json: { error: 'Authentication failed' }, status: :unauthorized
      end
    rescue Google::Auth::IDTokens::VerificationError => e
      render json: { error: 'Authentication failed' }, status: :unauthorized
    end
  end

  def logout
    @current_user.update(fcm_token: nil) if @current_user&.fcm_token.present?
    sign_out(@current_user) if defined?(sign_out)
    render json: { message: 'Logged out successfully. Please remove the token from the client.' }, status: :ok
  end

  def delete
    if current_user&.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: { errors: current_user&.errors&.full_messages || ['User not found'] }, status: :unprocessable_entity
    end
  end
end
  