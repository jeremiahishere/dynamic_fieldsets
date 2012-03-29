module DynamicFieldsets
  # Creates checkbox tags on a form
  #
  # Includes support for predefined field options and multiple selected answers
  class CheckboxField < Field
    acts_as_field_with_field_options
    acts_as_field_with_multiple_answers

    # Note that the checkbox needs individual data for each of the included options
    # This means that some things, such as the name are duplicated for each field option
    # 
    #
    # @return [Hash] Data needed for the checkbox form partial
    def form_partial_locals(args)
      output = super
      output[:options] = []
      field_options.each do |option|
        # rails is screwing up the ids just for the checkbox field
        # this is a (hopefully) temporary solution/hack to get the id right (JH 3-29-2012)
        # another possibility would be to update the html attributes method and add fsa and fsc arguments to it
        adjusted_html_attributes = html_attribute_hash.merge({
          :id => "#{DynamicFieldsets.config.form_fieldset_associator_prefix}#{args[:fsa].id}_#{DynamicFieldsets.config.form_field_prefix}#{args[:fieldset_child].id}_#{option.id.to_s}"
        });

        output[:options] << {
          :name => "#{DynamicFieldsets.config.form_fieldset_associator_prefix}#{args[:fsa].id}[#{DynamicFieldsets.config.form_field_prefix}#{args[:fieldset_child].id}][]",
          :value => option.id.to_s,
          :checked => values_or_defaults_for_form(args[:values]).include?(option.id.to_s),
          :label => option.name,
          :html_attributes =>           
        }
      end
      return output
    end 
  end
end
