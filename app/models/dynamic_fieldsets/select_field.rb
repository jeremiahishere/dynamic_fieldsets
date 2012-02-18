module DynamicFieldsets
  class SelectField < Field
    acts_as_field_with_field_options
    acts_as_field_with_one_answer

    def form_partial_locals(args)
      super.merge({
        :selected_id => value_or_default_for_form(args[:value]),
        :collection => self.options
      })
    end
  end
end

