class MyExplorationsController < ApplicationController

  before_action :authorized

  def all_explorations
    explorations = current_user.explorations
    render json: explorations, each_serializer: ExplorationSerializer, status: 200
  end

  def update
    exploration = current_user.explorations.find(params[:id])
    exploration.update(exploration_params)
    render json: exploration, status: 200
  end
  
  def create
    new_exploration = Exploration.new(exploration_params)
    new_exploration.user_id = current_user.id
    new_exploration.save
    render json: new_exploration, status: 200
  end
  
  def destroy
    exploration = current_user.explorations.find(params[:id])
    exploration.destroy
  end
  
  private

    def exploration_params
      params.require(:exploration).permit(:text, sources: [])
    end
end