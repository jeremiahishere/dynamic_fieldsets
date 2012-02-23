module DynamicFieldsets
  # Textarea input
  #
  # Note that this one is a little different than normal because the textarea does not store it's data
  # in a value attribute
  class TextareaField < Field
    acts_as_field_with_one_answer

    # @return [Integer] Default number of columns for the textarea
    def default_cols
      40
    end

    # @return [Integer] Default number of rows for the textarea
    def default_rows
      6
    end

    # @return [Hash] Html attributes for the textarea with default cols and rows if none are set
    def html_attribute_hash
      # this should get overriden by attributes the user sets
      # with the call to super
      output = {
        :cols => default_cols,
        :rows => default_rows,
      }
      output.merge!(super)
      return output
    end

    # @return [Hash] Data for the form partial
    def form_partial_locals(args)
      output = super
      output[:content] = value_or_default_for_form(args[:value])
      output[:attrs][:name] = output[:name]
      return output
    end
  end
end

