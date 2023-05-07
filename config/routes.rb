Rails.application.routes.draw do
#   resources :questions, only: [:index, :show, :create]
  root 'homepage#index'

  get "/questions", to: "questions#index"
  get "/questions/:id", to: "questions#show"
  get "/ask", to: "questions#ask"
end
