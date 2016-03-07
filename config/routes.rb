RetroNotes::Application.routes.draw do
  devise_for :users,
             path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification',
                           unlock: 'unblock', sign_up: 'register' },
             :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks', registrations: 'users/registrations'}


  resources :users do
    resources :retro_boards
  end

  delete '/delete_project/:id', to: 'retro_boards#delete_project', as: 'delete_project'
  delete '/delete_retro_card/:id', to: 'retro_boards#delete_retro_card', as: 'delete_retro_card'
  get '/upvote_retro_card/:id', to: 'retro_boards#upvote_retro_card', as: 'upvote_retro_card'
  get '/downvote_retro_card/:id', to: 'retro_boards#downvote_retro_card', as: 'downvote_retro_card'
  post '/retro_boards/:id/retro_panels/:retro_panel_id', to: 'retro_boards#create_retro_card', as: 'create_retro_card'

  root 'retro_boards#index'

end
