Rails.application.routes.draw do
  namespace :dynamic_fieldsets do
    match "/fieldsets/:id/children" => "fieldsets#children", :as => :children_dynamic_fieldsets_fieldset
    match "/fieldsets/:id/children/reorder" => "fieldsets#reorder"
    match "/fieldsets/new(/:parent)" => "fieldsets#new", :as => :new_dynamic_fieldsets_fieldset
    match "/fields/new(/:parent)" => "fields#new", :as => :new_dynamic_fieldsets_field
    resources :fieldset_associators
    match "/fieldsets/roots" => "fieldsets#roots"
    resources :fieldsets
    resources :fields
    resources :fieldset_children
  end

end
