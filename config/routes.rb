Rails.application.routes.draw do
  devise_for :users

  resources :question_groups do
    get 'results', on: :member

    resources :questions
    resources :answer_groups, only: [:new, :create]
  end

  root :to => "question_groups#index"

  resources :users
  get '/me', to: 'users#me', as: :user_profile
end
