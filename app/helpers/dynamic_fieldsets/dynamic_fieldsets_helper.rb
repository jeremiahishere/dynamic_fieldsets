module DynamicFieldsets
  module DynamicFieldsetsHelper
    include ActionView::Helpers
    
    # This helper does ..
    # @param [FieldsetAssociator] fsa parent FieldsetAssociator
    # @param [Field] field The Field to render
    # @param [Array] values Stored values for the field
    # @return [Array] The HTML elements for the field
    def field_renderer(fsa, field, values = [])
      classes  = "#{field.type} "
      classes += ( field.required ? 'required' : 'optional' )
      
      field_markup = ["<li class='#{classes}' id='field-input-#{field.id}'>"]
      field_markup.push "<label for='field-#{field.id}'>"
      field_markup.push "#{field.label}"
      field_markup.push "<abbr title='required'>*</abbr>" if field.required?
      field_markup.push "</label>"
      
      attrs = { id: "field-#{field.id}" }
      field.html_attributes.each{ |att,val| attrs.merge att.to_sym => val }
      
      case field.type.to_sym
      when :select
        attrs.merge disabled: 'disabled' unless field.enabled
        # handle defaults and saved vals
        field_markup.push collection_select "fsa-#{fsa.id}", "field-#{field.id}", field.options, :id, :label, {}, attrs
        
      when :multiple_select
        attrs.merge multiple: 'multiple'
        attrs.merge disabled: 'disabled' unless field.enabled
        # handle defaults and saved vals
        field_markup.push collection_select "fsa-#{fsa.id}", "field-#{field.id}", field.options, :id, :label, {}, attrs
        
      when :radio
        field_markup.push "<div id='field-#{field.id}'>"
        field.options.each do |option|
          attrs[:id] = "field-#{field.id}-#{option.label.underscore}"
          attrs.merge checked: true if populate( field, values ).to_i.eql? option.id
          field_markup.push "<label for='#{attrs[:id]}'>"
          field_markup.push radio_button "fsa-#{fsa.id}", "field-#{field.id}", option.id, attrs
          field_markup.push "#{option.label}"
          field_markup.push "</label>"
        end
        field_markup.push "</div>"

        
      when :checkbox
        field_markup.push "<div id='field-#{field.id}'>"
        field.options.each do |option|
          attrs[:id] = "field-#{field.id}-#{option.label.underscore}"
          # handle defaults and saved vals
          field_markup.push "<label for='#{attrs[:id]}'>"
          field_markup.push check_box "fsa-#{fsa.id}", "field-#{field.id}", attrs
          field_markup.push "#{option.label}"
          field_markup.push "</label>"
        end
        field_markup.push "</div>"
        
      when :textfield
        attrs.merge disabled: 'disabled' unless field.enabled
        attrs.merge value: populate( field, values )
        field_markup.push text_field "fsa-#{fsa.id}", "field-#{field.id}", attrs
        
      when :textarea
        attrs.merge disabled: 'disabled' unless field.enabled
        attrs.merge cols: '40' if !attrs.include? :cols
        attrs.merge rows: '20' if !attrs.include? :rows
        attrs.merge name: "fsa-#{fsa.id}[field-#{field.id}]"
        field_markup.push "<textarea #{attrs}>"
        field_markup.push populate( field, values )
        field_markup.push "</textarea>"
        
      when :date
        date_options = {  date_separator: '/',
                          add_month_numbers: true,
                          start_year: Time.now.year - 70 }
        date_options.merge disabled: true unless field.enabled
        # handle defaults and saved vals
        field_markup.push date_select "fsa-#{fsa.id}", "field-#{field.id}", date_options, attrs
        
      when :datetime
        date_options = {  add_month_numbers: true,
                          start_year: Time.now.year - 70 }
        date_options.merge disabled: true unless field.enabled
        # handle defaults and saved vals
        field_markup.push datetime_select "fsa-#{fsa.id}", "field-#{field.id}", date_options, attrs
        
      when :instruction
        field_markup.push "<p>#{field.label}</p>"
        
      end # case field.type
      
      field_markup.push "</li>"
      return field_markup
    end
    
    # This helper does ..
    # @param [FieldsetAssociator] fsa parent FieldsetAssociator
    # @param [Field] fieldset The Fieldset to render
    # @param [Array] values Stored values for the fieldset
    # @return [Array] The HTML elements for the fieldset
    def fieldset_renderer(fsa, fieldset, values)
      lines = ["<div id='fieldset-#{fieldset.id}' class='inputs'>"]
      lines.push "<ol>"
      fieldset.children.each do |child|
        if child.is_a? Field then
          lines += field_renderer( fsa, child, values[child.id] )
        else # child.is_a? Fieldset
          lines += fieldset_renderer( fsa, child, values )
        end
      end
      lines.push "</ol>"
      lines.push "</div>"
      return lines
    end
    
    # This helper ..
    # @param [FieldsetAssociator] The fieldset associator for the dynamic fieldset to render
    # @return [String] The HTML for the entire dynamic fieldset
    def dynamic_fieldset_renderer(fsa)
      rendered_dynamic_fieldset = ""
      fieldset_renderer( fsa, fsa.fieldset, fsa.field_values ).each do |line|
        rendered_dynamic_fieldset += line + "\n"
      end
      return rendered_dynamic_fieldset
    end
    
    # @param [Field] field
    # @param [String] value
    # @return [String] 
    # I know this is messy; Yeah, this is what happens when we are behind deadline.
    def populate(field, value)
      if !value.empty?
        return value
      elsif !field.default.empty?
        return field.default.value
      else
        return ""
      end
    end
    
  end
end
