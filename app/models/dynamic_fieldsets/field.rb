module DynamicFieldsets
  # Base class for various fieldtypes, i.e. questions
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Field < ActiveRecord::Base
    # Relations
    belongs_to :fieldset

    # Validations
    validates_presence_of :label
    validates_presence_of :order_num

    # @return [String] Alias for label property
    def name
      self.label
    end

    # @params [Array] values Saved values for this field provided by FieldsetAssociator.
    # @return [String] Haml markup for this field.
    def markup( values = [] )
      haml  = "%input{ "
      haml += "id: 'field-" + id.to_s + "', "
      haml += "label: '" + label.to_s + "', "
      haml += "value: '" + values.first.to_s + "' "
      haml += "}"
      haml
    end
    
    # @params [Hash] fieldset_values Collection of saved values provided by FieldsetAssociator. e.g. { field_id_1: ['field_value_1', ...], ... }
    # @return [Array] Indented haml markup for this field.
    def collect_markup( fieldset_values, lines, depth )
      padding = ""
      depth.times.each{ padding += "  " }
      [ padding + self.markup(fieldset_values[self.id]) ]
    end

  end
end