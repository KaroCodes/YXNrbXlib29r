Rails.application.routes.draw do
  root 'homepage#index'

  get "/ask", to: "questions#ask"
  get "/random", to: "questions#random"
end
