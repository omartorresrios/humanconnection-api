class Users::FirebaseAuthController < ApplicationController

  before_action :authorized
  
  def save_fcm_token
    current_user.update_attribute(:fcm_token, request.headers['HTTP_FCM_TOKEN'])
    render json: { status: 'FCM token saved' }, status: :ok
  end
end
