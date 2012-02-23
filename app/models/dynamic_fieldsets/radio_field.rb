module DynamicFieldsets
  class RadioField < Field
    acts_as_field_with_field_options
    acts_as_field_with_one_answer

    # not sure that this actually works
    def form_partial_locals(args)
      output = {}
      field.options.each do |option|
        output[option.id] = {}
        output[option.id][:id] = "field-#{self.id}-#{option.name.parameterize}"
        output[option.id][:checked] = value_or_default_for_form(args[:value].to_i.eql?(option.id))
        output[option.id].merge!(html_attribute_hash)
      end

      output.merge!(super)
      output.merge!({
        :field => self
      })
      return output
    end
  end
end

