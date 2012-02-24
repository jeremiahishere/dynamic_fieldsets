# this file was stolen from kaminari
require 'active_support/configurable'

module DynamicFieldsets

  # create new configs by passing a block with the config assignment
  def self.configure(&block)
    yield @config ||= DynamicFieldsets::Configuration.new
  end

  def self.config
    @config
  end

  # setup config data
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :available_field_types
    config_accessor :form_fieldset_associator_prefix
    config_accessor :form_field_prefix

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call() : config.param_name
    end
  end

  # setup default options
  # this should match the generator config that goes in the initializer file
  configure do |config|
    config.available_field_types = [ 
      "DynamicFieldsets::CheckboxField", 
      "DynamicFieldsets::DateField", 
      "DynamicFieldsets::DatetimeField", 
      "DynamicFieldsets::InstructionField", 
      "DynamicFieldsets::MultipleSelectField", 
      "DynamicFieldsets::RadioField", 
      "DynamicFieldsets::SelectField", 
      "DynamicFieldsets::TextField", 
      "DynamicFieldsets::TextareaField"
    ]
    config.form_fieldset_associator_prefix = "fsa-"
    config.form_field_prefix = "field-"
  end
end

