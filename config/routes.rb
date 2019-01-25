Rails.application.routes.draw do
  root "welcome#index", as: :welcome_index

  resources :sessions do
    get "forgot", on: :collection
  end
  get "login", to: "sessions#show"

end
