class MyExplorationsController < ApplicationController

  before_action :authenticate_request

  def all_explorations_with_similar
    current_user_explorations = current_user.explorations
    render json: current_user_explorations, each_serializer: ExplorationSerializer, status: 200
  end

  def similar_explorations
    exploration = current_user.explorations.find(params[:id])
    similar_exploration_ids = exploration.similar_exploration_ids
    similar_explorations = Exploration.where(id: similar_exploration_ids)
    render json: similar_explorations, each_serializer: ExplorationSerializer
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