module DynamicFieldsets
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

    def html_attributes_hash
      output = {
        :cols => default_cols,
        :rows => default_rows,
      }
      output.merge(super)
      return output
    end

    def form_partial_locals(args)
      output = super
      output[:attrs][:name] = output[:name]
      return output
    end
  end
end

