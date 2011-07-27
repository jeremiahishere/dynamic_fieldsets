Rails.application.routes.draw do
  namespace :dynamic_fieldsets do
    resources :fieldset_associators
    resources :fieldsets
    match "/fieldsets/:id/children" => "fieldsets#children", :as => :children_dynamic_fieldsets_fieldset
    resources :fields
  end

end
