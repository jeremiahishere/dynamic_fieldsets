module DynamicFieldsets
  # Creates checkbox tags on a form
  #
  # Includes support for predefined field options and multiple selected answers
  class CheckboxField < Field
    acts_as_field_with_field_options
    acts_as_field_with_multiple_answers

    # Note that the checkbox needs individual data for each of the included options
    # This means that some things, such as the name are duplicated for each field option
    # 
    #
    # @return [Hash] Data needed for the checkbox form partial
    def form_partial_locals(args)
      output = super
      output[:options] = []
      field_options.each do |option|
        output[:options] << {
          :name => "fsa-#{args[:fsa].id}[field-#{args[:fieldset_child].id}][]",
          :value => option.id.to_s,
          :checked => values_or_defaults_for_form(args[:values]).include?(option.id.to_s),
          :label => option.name,
          :html_attributes => html_attribute_hash
        }
      end
      return output
    end 
  end
end
