Rails.application.routes.draw do
  root "applicants#new"
  resources :applicants, only: [:edit, :create, :new]
  put "/applicant", to: "applicants#update"
end
