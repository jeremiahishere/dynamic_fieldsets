Rails.application.routes.draw do
  namespace :dynamic_fieldsets do
    resources :fieldset_associators

    resources :fieldsets
    match "/fieldsets/roots" => "fieldsets#roots"
    match "/fieldsets/:id/children" => "fieldsets#children", :as => :children_dynamic_fieldsets_fieldset
    match "/fieldsets/:id/children/reorder" => "fieldsets#reorder"
    match "/fieldsets/new(/:parent)" => "fieldsets#new", :as => :new_dynamic_fieldsets_fieldset
    match "fieldsets/:id/associate_child" => "fieldsets#associate_child", :as => :associate_child_to_fieldset

    resources :fields
    match "/fields/new(/:parent)" => "fields#new", :as => :new_dynamic_fieldsets_field
    match "/fields/:id/enable" => "fields#enable", :as => "enable_field", :method => :post

    resources :fieldset_children
  end

end
