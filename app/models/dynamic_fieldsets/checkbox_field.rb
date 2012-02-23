module DynamicFieldsets
  class CheckboxField < Field
    acts_as_field_with_field_options
    acts_as_field_with_multiple_answers

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
