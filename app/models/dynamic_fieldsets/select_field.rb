module DynamicFieldsets
  class SelectField < Field
    acts_as_field_with_field_options
    acts_as_field_with_one_answer

    # @return [Hash] data for the form partial
    def form_partial_locals(args)
      super.merge({
        :selected_id => value_or_default_for_form(args[:value]).to_i,
        :collection => self.options
      })
    end
  end
end

