module DynamicFieldsets
  # Base class for various fieldtypes, i.e. questions
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Field < ActiveRecord::Base
    set_table_name "dynamic_fieldsets_fields"
    # Relations
    
    # parents
    has_many :fieldset_children, :dependent => :destroy, :as => :child
    has_many :parent_fieldsets, :source => :fieldset, :foreign_key => "fieldset_id", :through => :fieldset_children, :class_name => "Fieldset"

    has_many :field_options
    accepts_nested_attributes_for :field_options, :allow_destroy => true

    has_many :field_defaults
    accepts_nested_attributes_for :field_defaults, :allow_destroy => true

    has_many :field_html_attributes
    accepts_nested_attributes_for :field_html_attributes, :allow_destroy => true

    #has_many :dependency_groups
    #accepts_nested_attributes_for :dependency_groups, :allow_destroy => true

    # Validations
    validates_presence_of :name
    validates_presence_of :label
    # removing this validation until the sti code is inplace
    # changed the field name from field_type to type so rails is trying to find models
    # validates_presence_of :type
    validates_inclusion_of :enabled, :in => [true, false]
    validates_inclusion_of :required, :in => [true, false]
    validate :has_field_options, :type_in_types

    # validates inclusion of wasn't working so I made it a custom validation
    # refactor later when I figure out how rails works
    def type_in_types
      if !Field.field_types.include?(self.type)
        # removing this validation until the sti code is inplace
        # changed the field name from field_type to type so rails is trying to find models
        # self.errors.add(:type, "The field type must be one of the available field types.")
      end
    end
    
    # Custom validation for fields with multiple options on update
    def has_field_options
      if options? && self.field_options.empty?
        self.errors.add(:field_options, "This field must have options")
      end
    end

    # @returns [Array] An array of allowable field types
    def self.field_types
      ["select", "multiple_select", "checkbox", "radio", "textfield", "textarea", "date", "datetime", "instruction"]
    end

    # @returns [Array] An array of field types that use options
    def self.option_types
      ["select", "multiple_select", "checkbox", "radio"]
    end
    
    # @return [Boolean] True if the field is of type 'select', 'multiple_select', 'radio', or 'checkbox'
    def options?
      Field.option_types.include? self.type
    end
    
    # @return [FieldOptions] Returns all field options that are enabled
    def options
      return self.field_options.reject{ |option| !option.enabled }
    end
    
    # @return [Boolean] False if field_default.value is empty
    def has_defaults?
      return self.field_defaults.length > 0
    end
    
    # @return [Array] Alias for field_defaults
    def defaults
      return self.field_defaults if options?
      return nil
    end
    
    # @return [String] Alias for field_defaults.first
    def default
      return nil if options?
      return self.field_defaults.first
    end

    # @return [Boolean] True if there are any field records for the field or if it is in any fieldsets
    def in_use?
      self.fieldset_children.count { |child| !child.fieldset_id.nil? || !child.field_records.empty? } > 0
    end
    
  end
end
