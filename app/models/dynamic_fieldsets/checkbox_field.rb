module DynamicFieldsets
  class CheckboxField < Field
    acts_as_field_with_field_options
    acts_as_field_with_multiple_answers

    def form_partial_locals(args)
      output = {}
      field.options.each do |option|
        output[option.id] = {}
        output[option.id][:id] = "field-#{field.id}-#{option.name.underscore}"
        output[option.id][:name] = "fsa-#{args[:fsa].id}[field-#{args[:fieldset_child].id}][]"
        output[option.id][:selected] = values_or_defaults_for_form(args[:values]).include?(option.id)
        output[option.id].merge(html_attribute_hash)
      end
      output.merge(super)
      output.merge({
        :fsa => args[:fsa],
        :fieldset_child => args[:fieldset_child],
        :field => self
      })
      return output
    end 
  end
end
