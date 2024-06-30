class MyExplorationsController < ApplicationController

  # before_action :authenticate_user!

  def all_explorations
      explorations = Exploration.all#current_user.explorations
      render json: explorations, each_serializer: ExplorationSerializer, status: 200
    end
  
  #   def update
  #     note = current_user.notes.find(params[:id])
  #     note.update(note_params)
  #     render nothing: true, status: 204
  #   end
  
  def create
    new_exploration = Exploration.new(exploration_params)
    new_exploration.user_id = 1#current_user.id
    new_exploration.save
    render json: new_exploration, status: 200
  end
  
  #   def destroy
  #     note = current_user.notes.find(params[:id])
  #     note.destroy
  #   end
  private

    def exploration_params
      params.require(:exploration).permit(:text, sources: [])
    end
end