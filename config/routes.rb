RetroNotes::Application.routes.draw do
  resources :users do
    resources :retro_boards
  end

  devise_for :users,
             path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification',
                           unlock: 'unblock', sign_up: 'register' },
             :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks', registrations: 'users/registrations'}


  # get 'welcome/index'

  root 'retro_boards#index'

end
