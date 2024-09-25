class Users::AuthenticationController < ApplicationController

    def valid_token
      begin
        payload = Google::Auth::IDTokens.verify_oidc(request.headers['HTTP_AUTHORIZATION_TOKEN'], aud: ENV["GOOGLE_OAUTH_CLIENT_ID"])
        @current_user = User.from_google_payload(payload)
        sign_in(@current_user)
        render json: @current_user, serializer: UserSerializer, status: 200
      rescue Google::Auth::IDTokens::VerificationError => e
        puts "JWT Verification Error: #{e.message}"
        nil
      end
    end
  
    def logout
      sign_out(@current_user)
    end
  
    def delete
      user = User.find(params[:id])
      user.destroy
    end
  end
  