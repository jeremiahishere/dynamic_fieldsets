Rails.application.routes.draw do
  namespace :dynamic_fieldsets do
    resources :fieldset_associators
  end
end
