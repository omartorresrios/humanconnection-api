class Users::FirebaseAuthController < ApplicationController

  before_action :authorized
  
    def save_fcm_token
      if request.format.json?
        current_user.update_attribute(:fcm_token, request.headers['HTTP_FCM_TOKEN'])
        render json: { status: 'FCM token saved' }, status: :ok
      else
        render json: { error: 'Unsupported format' }, status: :unsupported_media_type
      end
    end
  end
  