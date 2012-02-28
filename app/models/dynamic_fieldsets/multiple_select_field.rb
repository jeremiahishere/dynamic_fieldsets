module DynamicFieldsets
  # A select field that handles multiple selections
  #
  # Even though it just uses a select tag helper with multiple: true, the backend is quite different
  # from the select field.  It uses the multiple_answers mixin and all of the value and default
  # methods return arrays instead of strings.
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
      super.merge!({
        :selected_ids => values_or_defaults_for_form(args[:values]),
        :collection => self.options
      })
    end

    # this returns field option ids based on the field default values
    # due to funness with field options
    #
    # there is a good chance this is only needed due to a bug in multiple select's save default method 
    # We may need to take a look at this in the future.  I think it could be moved to a mixin. (JH 2-28-2012)
    # @return [Array] An array of field option ids that correspond to the field defaults
    def collect_default_values
      output = []
      field_defaults.each do |default|
        # find a field option with the same name as the default
        # add it's id to the output
        output << field_options.select { |option| option.name == default.value }.first.id
      end
      return output
    end
  end
end

