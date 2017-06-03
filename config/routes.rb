Rails.application.routes.draw do
  root "applicants#new"
  resources :applicants, only: [:edit, :create, :new]
  put "/applicant", to: "applicants#update"
  post "/applicant/session", to: "applicants#establish_session"
  resources :linkedin_accounts, only: [:create]
end
