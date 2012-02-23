module DynamicFieldsets
  # Radio buttons input
  class RadioField < Field
    acts_as_field_with_field_options
    acts_as_field_with_one_answer

    # Note that the radio buttons need special data per field option
    # output[:options] contains information for each of the field options for the radio field
    #
    # @return [Hash] Data needed for the radio buttons partial
    def form_partial_locals(args)
      output = super
      output[:options] = []
      field_options.each do |option|
        output[:options] << {
          :name => "fsa-#{args[:fsa].id}[field-#{args[:fieldset_child].id}][]",
          :value => option.id.to_s,
          :checked => value_or_default_for_form(args[:values]).eql?(option.id.to_s),
          :html_attributes => html_attribute_hash,
          :label => option.name,
        }
      end
      return output
    end
  end
end

