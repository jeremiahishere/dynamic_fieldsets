module DynamicFieldsets
  class RadioField < Field
    acts_as_field_with_field_options
    acts_as_field_with_one_answer
  end
end

