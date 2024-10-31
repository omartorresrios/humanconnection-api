require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  devise_for :users
  
  scope '/api' do
    #MyExplorationsController
    get 'all_explorations_with_similar' => 'my_explorations#all_explorations_with_similar'
    get 'similar_explorations' => 'my_explorations#similar_explorations'
    put 'update_exploration' => 'my_explorations#update'
    post 'create_exploration' => 'my_explorations#create'
    post 'delete_exploration' => 'my_explorations#destroy'
    put 'update_profile' => 'my_profile#update'
    
    # NotificationsController
    post 'mark_all_notifications_as_read' => 'notifications#mark_all_as_read'

    # UsersController
    namespace :users do
      post 'auth/login' => 'authentication#valid_token'
      post 'auth/save_fcm_token' => 'firebase_auth#save_fcm_token'
      post 'auth/logout' => 'authentication#logout'
      delete 'auth/delete' => 'authentication#delete'
    end
  end
end
