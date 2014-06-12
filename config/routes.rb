Rails.application.routes.draw do
  devise_for :users

  resources :question_groups do
    get 'results', on: :member
    resources :questions
    resources :answer_groups, only: [:new, :create, :show]
  end
  post 'question_groups/:id/assign_to_user/:user_id', to: 'question_groups#assign_to_user', as: :assign_to_user

  root :to => "users#me"

  resources :users
  get '/users/:id/assign_quiz', to: 'users#assign_quiz', as: :assign_quiz
  get '/me', to: 'users#me', as: :user_profile

  get '/ping', to: 'application#ping'
end
