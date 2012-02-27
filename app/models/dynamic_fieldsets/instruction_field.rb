module DynamicFieldsets
  # A special field used only for instruction
  # No user input is included
  #
  # Note that this field does not use the default header and footer partials for the fields
  class InstructionField < Field
    # no answers possible, need an include for this?

    def show_partial
      "/dynamic_fieldsets/show_partials/show_instruction"
    end
    # @return [Boolean] False because this field does not have the standard question: answer styling
    def use_form_header_partial?
      false
    end

    # @return [Boolean] False because this field does not have the standard question: answer styling
    def use_form_footer_partial?
      false
    end

    # @return [Hash] The label for the instruction plus the rest of the partial data
    def form_partial_locals(args)
      output = super
      output[:label] = self.label
      return output
    end

    # Do not update any options for the instruction
    def update_field_records(fsa, fieldset_child, value)
      # do nothing
    end
  end
end

