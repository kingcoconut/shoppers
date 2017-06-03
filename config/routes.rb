Rails.application.routes.draw do
  root "applicants#new"
  resources :applicants, only: [:edit, :create, :new]
  put "/applicant", to: "applicants#update"
  resources :linkedin_accounts, only: [:create]
end
