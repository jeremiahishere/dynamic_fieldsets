module DynamicFieldsets
  module DynamicFieldsetsHelper
    
    # This helper does ..
    # @param [Form] form The parent form of the field
    # @param [Field] field The Field to render
    # @param [Array] values Stored values for the field
    # @return [Array] The HTML elements for the field
    def field_renderer(field, form, values = [])
      classes  = "#{field.type} "
      classes += ( field.required ? 'required' : 'optional' )
      
      field_markup = ["<li class='#{classes}' id='field-input-#{field.id}'>"]
      field_markup.push "<label for='field-#{field.id}'>"
      field_markup.push "#{field.label}"
      field_markup.push "<abbr title='required'>*</abbr>" if field.required?
      field_markup.push "</label>"
      
      elem ""
      elem += " name='fsa-#{field.fieldset.fieldset_associator.id}[field-#{field.id}]'"
      elem += " id='field-#{field.id}'"
      elem += " value='#{field.defaults}'"
      field.html_attributes.each{ |att,val| elem += " #{att}='#{val}'" }
      
      field_markup.push "</li>"
      return field_markup
    end
    
    # This helper does ..
    # @param [Form] form The parent form of the fieldset
    # @param [Field] fieldset The Fieldset to render
    # @param [Array] values Stored values for the fieldset
    # @return [Array] The HTML elements for the fieldset
    def fieldset_renderer(fieldset, form, values)
      lines = ["<div id='fieldset-#{fieldset.id}' class='inputs'>"]
      lines.push "<ol>"
      fieldset.children.each do |child|
        if child.is_a? Field then
          lines += field_renderer( child, form, values[child.id] )
        else # child.is_a? Fieldset
          lines += fieldset_renderer( child, form, values )
        end
      end
      lines.push "</ol>"
      lines.push "</div>"
      return lines
    end
    
    # This helper ..
    # @param [Form] form The parent form of the dynamic fieldset
    # @param [FieldsetAssociator] The fieldset associator for the dynamic fieldset
    # @return [String] The HTML for the entire dynamic fieldset
    def dynamic_fieldset_renderer(form, fsa)
      rendered_dynamic_fieldset = ""
      fieldset_renderer( form, fsa.fieldset, fsa.field_values ).each do |line|
        rendered_dynamic_fieldset += line + "\n"
      end
      return rendered_dynamic_fieldset
    end
    
  end
end