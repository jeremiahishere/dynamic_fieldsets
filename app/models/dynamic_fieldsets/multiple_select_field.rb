module DynamicFieldsets
  class MultipleSelectField < Field
    acts_as_field_with_field_options
    acts_as_field_with_multiple_answers
  end
end

