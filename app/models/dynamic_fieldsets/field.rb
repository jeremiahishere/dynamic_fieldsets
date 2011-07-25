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
    validates_presence_of :order_num
    validates_inclusion_of :type, :in => %w( select multiple_select checkbox radio textfield textarea date datetime instruction )
    validate :has_field_options
    
    # Custom validation for fields with multiple options
    def has_field_options
      if %w[select multiple_select radio checkbox].include? self.type
        self.errors.add(:field_options, "This field must have options")
      end
    end
    
    # @return [Boolean] True if the field is of type 'select', 'multiple_select', 'radio', or 'checkbox'
    def options?
      %w[select multiple_select radio checkbox].include? self.type
    end
    
    # @return [Boolean] True if the field is required.
    def required?
      return self.required
    end
    
    # @return [Boolean] True if the field is enabled.
    def enabled?
      return self.enabled
    end
    
    # @return [Boolean] False if field_default.value is empty
    def has_default?
      !self.field_default.value.empty?
    end
    
    # @return [String] Alias for field_default.value
    def default
      return self.field_default.value
    end
    
  end
end