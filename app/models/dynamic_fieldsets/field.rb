module DynamicFieldsets
  # Base class for various fieldtypes, i.e. questions
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Field < ActiveRecord::Base
    # Relations
    belongs_to :fieldset
    has_many :field_options
    accepts_nested_attributes_for :field_options, :allow_destroy => true

    has_many :field_defaults
    has_many :field_html_attributes

    # Validations
    validates_presence_of :name
    validates_presence_of :label
    validates_presence_of :field_type
    validates_presence_of :order_num
    validates_inclusion_of :enabled, :in => [true, false]
    validates_inclusion_of :required, :in => [true, false]
    validate :has_field_options, :field_type_in_field_types

    # validates inclusion of wasn't working so I made it a custom validation
    # refactor later when I figure out how rails works
    def field_type_in_field_types
      if !Field.field_types.include?(self.field_type)
        self.errors.add(:field_type, "The field type must be one of the available field types.")
      end
    end
    
    # Custom validation for fields with multiple options
    def has_field_options
      if options? 
        self.errors.add(:field_options, "This field must have options")
      end
    end

    # @returns [Array] An array of allowable field types
    def self.field_types
      ["select", "multiple_select", "checkbox", "radio", "textfield", "textarea", "date", "datetime", "instruction"]
    end

    # @returns [Array] An array of field types that use options
    def self.option_field_types
      ["select", "multiple_select", "checkbox", "radio"]
    end
    
    # @return [Boolean] True if the field is of type 'select', 'multiple_select', 'radio', or 'checkbox'
    def options?
      Field.option_field_types.include? self.field_type
    end
    
    # @return [FieldOptions] Alias
    def options
      return self.field_options.reject{ |option| !option.enabled }
    end
    
    # @return [Boolean] False if field_default.value is empty
    def has_defaults?
      return self.field_defaults.length > 0
    end
    
    # @return [Array] Alias for field_defaults
    def defaults
      if self.options?
      then return self.field_defaults
      else nil
      end
    end
    
    # @return [String] Alias for field_defaults.first
    def default
      return self.field_defaults.first
    end
    
  end
end
