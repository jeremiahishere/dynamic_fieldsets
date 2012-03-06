module DynamicFieldsets
  # Base class for various field_defaults,
  # A text field would have a single default value
  # While a multiple select could have multiple default values
  #
  # @authors Scott Sampson, Jeremiah Hemphill, Ethan Pemble
  class FieldDefault < ActiveRecord::Base
    self.table_name = "dynamic_fieldsets_field_defaults"
    #relations
    belongs_to :field
    
    #validations
    validates_presence_of :value

    before_save :convert_option_name_to_id
    
    # When the field type is an option type, the saved value should be converted into an id
    # This needs to happen because the value field normally stores a string but sometimes stores a field option id
    #
    # In some cases, the field_option instance is not set before this, no idea what happens then
    #
    # http://www.youtube.com/watch?v=BeP6CpUnfc0 
    def convert_option_name_to_id
      if field.uses_field_options?
        option = FieldOption.where(:name => self.value, :field => self.field).first
        self.value = option.id unless option.nil?
      end
    end

    # @return [String] Either the value or the name of the field option reference by the value
    def pretty_value
      if !self.field.nil? && field.uses_field_options?
        option = FieldOption.find_by_id(self.value)
        if !option.nil?
          return option.name
        end
      end
      return self.value
    end
  end
end
