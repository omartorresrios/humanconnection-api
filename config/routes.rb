Rails.application.routes.draw do
  devise_for :users
  
  scope '/api' do
    #MyExplorationsController
    get 'all_explorations' => 'my_explorations#all_explorations'
    post 'update_exploration' => 'my_explorations#update'
    post 'create_exploration' => 'my_explorations#create'
    post 'delete_exploration' => 'my_explorations#destroy'
  end
end
