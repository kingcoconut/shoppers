Rails.application.routes.draw do
  root "applicants#new"
  resources :applicants, only: [:edit, :create, :new]
  put "/applicant", to: "applicants#update"
  post "/applicant/session", to: "applicants#establish_session"
  get "/funnels.json", to: "applicants#funnels"
  get "/v2/funnels.json", to: "dashboard#funnels"
  get "/v2/applicants.json", to: "dashboard#applicants"
  resources :linkedin_accounts, only: [:create]
  get "/dashboard", to: "dashboard#index"
end
