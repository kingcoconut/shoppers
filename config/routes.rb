Rails.application.routes.draw do
  # APPLICANT ROUTES
  root "applicants#new"
  resources :applicants, only: [:create, :new]
  get "/applicant/login", to: "applicants#login", as: "applicant_login"
  get "/applicant/edit", to: "applicants#edit", as: "applicant_edit"
  put "/applicant", to: "applicants#update"
  post "/applicant/session", to: "applicants#establish_session"
  delete "/applicant/session", to: "applicants#destroy_session"

  # REQUIREMENT ENDPOINT
  get "/funnels.json", to: "applicants#funnels"

  # ADMIN DASHBOARD ROUTES
  get "/v2/funnels.json", to: "dashboard#funnels"
  get "/v2/applicants.json", to: "dashboard#applicants"
  resources :linkedin_accounts, only: [:create]
  get "/dashboard", to: "dashboard#index", as: "admin"
end
