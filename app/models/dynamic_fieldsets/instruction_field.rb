module DynamicFieldsets
  class InstructionField < Field
    # no answers possible, need an include for this?

    # @return [Boolean] False because this field does not have the standard question: answer styling
    def use_default_header_and_footer_partials?
      return false
    end
  end
end

