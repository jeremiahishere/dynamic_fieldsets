require 'rails'

# no configuration yet
require 'dynamic_fieldsets/config'

module DynamicFieldsets
  class Railtie < ::Rails::Railtie
    initializer 'dynamic_fieldsets' do |app|
      require 'dynamic_fieldsets/dynamic_fieldsets_in_model'
      ActiveRecord::Base.send :include, DynamicFieldsets::DynamicFieldsetsInModel
      require 'dynamic_fieldsets/field_with_field_options'
      ActiveRecord::Base.send :include, DynamicFieldsets::FieldWithFieldOptions
      require 'dynamic_fieldsets/field_with_multiple_answers'
      ActiveRecord::Base.send :include, DynamicFieldsets::FieldWithMultipleAnswers
      require 'dynamic_fieldsets/field_with_single_answer'
      ActiveRecord::Base.send :include, DynamicFieldsets::FieldWithSingleAnswer
    end
  end
end
