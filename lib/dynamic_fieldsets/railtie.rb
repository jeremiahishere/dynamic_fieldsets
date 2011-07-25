require 'rails'

# no configuration yet
require 'dynamic_fieldsets/config'

module DynamicFieldsets
  class Railtie < ::Rails::Railtie
    initializer 'dynamic_fieldsets' do |app|
      require 'dynamic_fieldsets/multipart_form_in_model'
      ActiveRecord::Base.send :include, DynamicFieldsets::MultipartFormInModel
    end
  end
end
