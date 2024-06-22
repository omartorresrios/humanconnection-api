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
    
    #   def create
    #     new_note = Note.new(note_params)
    #     new_note.user_id = current_user.id
    #     new_note.save
    #     render json: new_note, status: 200
    #   end
    
    #   def destroy
    #     note = current_user.notes.find(params[:id])
    #     note.destroy
    #   end
end