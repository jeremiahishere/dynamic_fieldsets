module DynamicFieldsetsHelper
  #include ActionView::Helpers

  # Builds HTML for the provided field.
  # @param [FieldsetAssociator] fsa parent FieldsetAssociator
  # @param [FieldsetChild] fieldset_child The FieldsetChild to render
  # @param [Array] values Saved values for the field
  # @return [Array] The HTML elements for the field
  def field_renderer(fsa, fieldset_child, values = [], form_type)
    if form_type == "form"
      return field_form_renderer(fsa, fieldset_child, values)
    else
      return field_show_renderer(fsa, fieldset_child, values)
    end
  end


  # Builds HTML for the provided field for a show page.
  #
  # The code to get the names for fields using field options (select, multiple select, checkbox, and radio)
  # is not optimized to minimize hitting the database
  #
  # @param [FieldsetAssociator] fsa parent FieldsetAssociator
  # @param [FieldsetChild] fieldset_child The FieldsetChild to render
  # @param [Array] values Saved values for the field
  # @return [Array] The HTML elements for the field
  def field_show_renderer(fsa, fieldset_child, values = [])
    field = fieldset_child.child
    lines = []

    if field.use_show_header_partial?
      lines.push render(:partial => field.show_header_partial )
    end

    args = {
      :value => values,
      :values => values
    }
    lines.push render(:partial => field.show_partial, :locals => field.show_partial_locals(args) )

    if field.use_show_footer_partial?
      lines.push render(:partial => field.show_footer_partial )
    end

    return lines
  end

  # Builds HTML for the provided field for a form.
  # @param [FieldsetAssociator] fsa parent FieldsetAssociator
  # @param [FieldsetChild] fieldset_child The FieldsetChild to render
  # @param [Array] values Saved values for the field
  # @return [Array] The HTML elements for the field
  def field_form_renderer(fsa, fieldset_child, values = [])
    field = fieldset_child.child
    # maybe turn this into an instance method
    classes  = "#{field.type.gsub("DynamicFieldsets::", "").underscore.downcase} "
    classes += ( field.required ? 'required' : 'optional' )
    
    field_markup = []
    if field.use_form_header_partial?
      field_markup.push render(:partial => field.form_header_partial, :locals => {
          :classes => classes,
          :field => field,
          :fieldset_child => fieldset_child
        })
    end
      
    attrs = field.html_attribute_hash
    
    attributes = {
      :fsa => fsa,
      :fieldset_child => fieldset_child,
      :values => values,
      :value => values
    }

    field_markup.push render(:partial => field.form_partial, :locals => field.form_partial_locals(attributes))
    
    if field.use_form_footer_partial?
      field_markup.push render(:partial => field.form_footer_partial)
    end

    return field_markup
  end
  
  # Builds HTML for the provided fieldset and its children.
  # @param [FieldsetAssociator] fsa parent FieldsetAssociator
  # @param [Fieldset] fieldset The Fieldset to render
  # @param [Hash] values Stored values for the fieldset
  # @return [Array] The HTML elements for the fieldset
  def fieldset_renderer(fsa, fieldset, values, form_type)
    lines = ["<div id='fieldset-#{fieldset.id}' class='inputs'>"]
    lines.push "<h3 class='name'>#{fieldset.name}</h3>"
    lines.push "<ol>"

    # this returns field/fieldset objects rather than fieldset children
    # that is why this code looks like it is accessing odd objects
    fieldset.children.each do |child|
      if child.is_a? DynamicFieldsets::Fieldset
        lines += fieldset_renderer( fsa, child, values, form_type )
      else # one of many possible types of child
        fieldset_child = DynamicFieldsets::FieldsetChild.where( :child_id => child.id, :fieldset_id => fieldset.id, :child_type => "DynamicFieldsets::Field" ).first
        lines += field_renderer( fsa, fieldset_child, values[fieldset_child.id], form_type )
      end
    end

    lines.push "</ol>"
    lines.push "</div>"

    return lines
  end
  
  # Build HTML for a specific dynamic fieldset on a show page
  # @param [FieldsetAssociator] The fieldset associator for the dynamic fieldset to render
  # @return [String] The HTML for the entire dynamic fieldset
  def dynamic_fieldset_show_renderer(fsa)
    return dynamic_fieldset_renderer(fsa, "show")
  end

  # Build HTML for a specific dynamic fieldset on a form page
  # @param [FieldsetAssociator] The fieldset associator for the dynamic fieldset to render
  # @return [String] The HTML for the entire dynamic fieldset
  def dynamic_fieldset_form_renderer(fsa)
    return dynamic_fieldset_renderer(fsa, "form") << javascript_renderer(fsa)
  end

  # Builds HTML for a specific dynamic fieldset in a form.
  # @param [FieldsetAssociator] The fieldset associator for the dynamic fieldset to render
  # @return [String] The HTML for the entire dynamic fieldset
  def dynamic_fieldset_renderer(fsa, form_type)
    rendered_dynamic_fieldset = "<div id='#{DynamicFieldsets.config.form_fieldset_associator_prefix}#{fsa.id}'>\n"
    rendered_dynamic_fieldset += "<input type='hidden' name='#{DynamicFieldsets.config.form_fieldset_associator_prefix}#{fsa.id}[fieldset_id]' value='#{fsa.fieldset_id}' />\n"
    rendered_dynamic_fieldset += "<input type='hidden' name='#{DynamicFieldsets.config.form_fieldset_associator_prefix}#{fsa.id}[fieldset_model_name]' value='#{fsa.fieldset_model_name}' />\n"
    fieldset_renderer( fsa, fsa.fieldset, fsa.field_values, form_type ).each do |line|
      rendered_dynamic_fieldset += line + "\n"
    end
    rendered_dynamic_fieldset += "</div>"

    return rendered_dynamic_fieldset.html_safe
  end

  # sti version
  # this has been replaced by value_or_default_for_form
  #  
  # Method that returns the javascript in string format to be pushed on with the rest of the
  # generated form
  #
  # @params [FieldsetAssociator] The fieldset associator for the dynamic fieldset to render
  # @return [String] The javascript variable that shows what fields have dependencies
  def javascript_renderer(fsa)
    unless fsa.id == nil
      rendered_javascript = "<script type='text/javascript'> var json_holder = #{fsa.dependency_child_hash.to_json}; </script>"
      rendered_javascript += render "dynamic_fieldsets/shared/javascript_watcher"
      return rendered_javascript.html_safe
    else
      return ""
    end
  end

end
