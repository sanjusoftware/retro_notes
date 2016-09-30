RetroNotes::Application.routes.draw do
  devise_for :users,
             path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification',
                           unlock: 'unblock', sign_up: 'register' },
             :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks', registrations: 'users/registrations'}


  resources :retro_boards do
    resources :retro_panels do
      resources :retro_cards do
        member do
          get :downvote, :upvote
        end
      end
    end
  end

  get '/401_ajax', to: 'application#handle_401_ajax'

  delete '/delete_project/:id', to: 'retro_boards#delete_project', as: 'delete_project'
  put '/merge_cards', to: 'retro_cards#merge', as: 'merge_cards'

  root 'welcome#index'

end
