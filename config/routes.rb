Rails.application.routes.draw do
  root "applicants#new"
  resources :applicants, only: [:edit, :create, :new]
  put "/applicant", to: "applicants#update"
  post "/applicant/session", to: "applicants#establish_session"
  get "/funnels.json", to: "applicants#funnels"
  resources :linkedin_accounts, only: [:create]
  get "/dashboard", to: "dashboard#index"
end
