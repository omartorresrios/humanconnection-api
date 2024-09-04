class MyProfileController < ApplicationController
  
  before_action :authorized

  def update
    if current_user.update(user_params)
      render json: current_user, status: 200
    end
  end

  private
    def user_params
        params.require(:user).permit(:bio, :city)
    end
end