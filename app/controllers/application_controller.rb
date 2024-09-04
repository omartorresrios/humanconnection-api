class ApplicationController < ActionController::API

    def encode_token(payload)
        JsonWebToken.encode(payload)
    end

    def decoded_token
        header = request.headers['Authorization']
        if header
            token = header.split(" ")[1]
            JsonWebToken.decode(token)
        end
    end

    def current_user
        decoded_token ? User.find_by(id: decoded_token['user_id']) : nil
    end

    def authorized
        unless !!current_user
        render json: { message: 'Please log in' }, status: :unauthorized
        end
    end
  end