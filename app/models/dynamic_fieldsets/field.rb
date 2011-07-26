module DynamicFieldsets
  # Base class for various fieldtypes, i.e. questions
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Field < ActiveRecord::Base
    # Relations
    belongs_to :fieldset
    has_many :field_options
    has_many :field_defaults
    has_many :field_html_attributes

    # Validations
    validates_presence_of :name
    validates_presence_of :label
    validates_presence_of :type
    validates_inclusion_of :type, :in => %w( select multiple_select checkbox radio textfield textarea date datetime instruction )
    validates_presence_of :order_num
    validates_presence_of :enabled
    validates_inclusion_of :enabled, :in => [true, false]
    validates_presence_of :required
    validates_inclusion_of :required, :in => [true, false]
    validate :has_field_options
    
    # Custom validation for fields with multiple options
    def has_field_options
      if options? 
        self.errors.add(:field_options, "This field must have options")
      end
    end
    
    # @return [Boolean] True if the field is of type 'select', 'multiple_select', 'radio', or 'checkbox'
    def options?
      %w[select multiple_select radio checkbox].include? self.type
    end
    
    # @return [FieldOptions] Alias
    def options
      return self.field_options.reject{ |option| !option.active }
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
