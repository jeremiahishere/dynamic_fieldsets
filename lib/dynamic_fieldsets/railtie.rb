require 'rails'

# no configuration yet
require 'dynamic_fieldsets/config'

module DynamicFieldsets
  class Railtie < ::Rails::Railtie
    initializer 'dynamic_fieldsets' do |app|
      require 'dynamic_fieldsets/dynamic_fieldsets_in_model'
      ActiveRecord::Base.send :include, DynamicFieldsets::DynamicFieldsetsInModel
    end
  end
end
