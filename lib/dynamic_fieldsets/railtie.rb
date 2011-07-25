require 'rails'

# no configuration yet
require 'dynamic_fieldsets/config'

module DynamicFieldsets
  class Railtie < ::Rails::Railtie
    initializer 'dynamic_fieldsets' do |app|
      puts "including the model mixin theoretically"
      require 'dynamic_fieldsets/dynamic_fieldsets_in_model'
      debugger
      ActiveRecord::Base.send :include, DynamicFieldsets::DynamicFieldsetsInModel
    end
  end
end
