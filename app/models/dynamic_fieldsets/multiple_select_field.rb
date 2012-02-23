module DynamicFieldsets
  class MultipleSelectField < Field
    acts_as_field_with_field_options
    acts_as_field_with_multiple_answers

    # @return [Hash] Sets multiple to true along with the standard arguments
    def html_attribute_hash
      super.merge!({
        :multiple => true
      })
    end

    # @return [Hash] data for the form partial
    def form_partial_locals(args)
      super.merge({
        :selected_ids => values_or_defaults_for_form(args[:values]).map(&:to_i),
        :collection => self.options
      })
    end
  end
end

