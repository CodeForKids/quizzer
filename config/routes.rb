Rails.application.routes.draw do
  resources :quiz_groups

  devise_for :users

  resources :question_groups do
    member { post '/assign_to_user/:user_id', to: :assign_to_user, as: :assign_to_user }
    collection { post '/user/:user_id/assign_group/:group_id', to: :assign_group_to_user, as: :assign_group
     }
    get 'results', on: :member
    resources :questions
    resources :answer_groups, only: [:new, :create, :show]
  end

  root :to => "users#me"

  resources :users do
    member do
      get '/assign_quiz', to: :assign_quiz, as: :assign_quiz
    end
  end
  get '/me', to: 'users#me', as: :user_profile

  get '/ping', to: 'application#ping'
end
