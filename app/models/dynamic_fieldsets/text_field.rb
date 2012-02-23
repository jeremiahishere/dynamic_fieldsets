module DynamicFieldsets
  class TextField < Field
    acts_as_field_with_one_answer

    def form_partial_locals(args)
      output = super
      output[:attrs][:value] = value_or_default_for_form(args[:value])
      return output
    end
  end
end

