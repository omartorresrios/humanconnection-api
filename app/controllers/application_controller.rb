class ApplicationController < ActionController::API

  before_action :authenticate_request

	def encode_token(payload)
    JsonWebToken.encode(payload)
  end

  def decoded_token
    header = request.headers['Authorization']
    if header.present?
      token = header.split(" ").last
      begin
        JsonWebToken.decode(token)
      rescue JWT::DecodeError => e
        Rails.logger.error "JWT decode error: #{e.message}"
        nil
      end
    end
  end

  def current_user
    @current_user ||= User.find_by(id: decoded_token['user_id']) if decoded_token
  end

  def authenticate_request
    render json: { error: 'Not Authorized' }, status: :unauthorized unless current_user
  end
end