Rails.application.routes.draw do
  namespace :dynamic_fieldsets do
    match "/fieldsets/:id/children" => "fieldsets#children", :as => :children_dynamic_fieldsets_fieldset
    match "/fieldsets/new(/:parent)" => "fieldsets#new", :as => :new_dynamic_fieldsets_fieldset
    match "/fields/new(/:parent)" => "fields#new", :as => :new_dynamic_fieldsets_field
    resources :fieldset_associators
    resources :fieldsets do
      resources :fields
    end
    resources :fields
  end

end
