module DynamicFieldsetsHelper
  #include ActionView::Helpers
  
  # Builds HTML for the provided field.
  # @param [FieldsetAssociator] fsa parent FieldsetAssociator
  # @param [Field] field The Field to render
  # @param [Array] values Saved values for the field
  # @return [Array] The HTML elements for the field
  def field_renderer(fsa, field, values = [], form_type)
    if form_type == "form"
      return field_form_renderer(fsa, field, values)
    else
      return field_show_renderer(fsa, field, values)
    end
  end


  # Builds HTML for the provided field for a show page.
  # @param [FieldsetAssociator] fsa parent FieldsetAssociator
  # @param [Field] field The Field to render
  # @param [Array] values Saved values for the field
  # @return [Array] The HTML elements for the field
  def field_show_renderer(fsa, field, values = [])
    lines = []
    lines.push "<div class='dynamic_fieldsets_field'>"
    lines.push "<div class='dynamic_fieldsets_field_label'>#{field.label}</div>"
    lines.push "<div class='dynamic_fieldsets_field_value'>"
    if values
      if field.field_type == "multiple_select" || field.field_type == "checkbox"
        values.each do |value|
          lines.push value.to_s + "<br />"
        end
      elsif field.field_type == "select" || field.field_type == "radio"
        lines.push values.to_s
      else
        lines.push values
      end
    else
      lines.push "No answer given"
    end
    lines.push "</div>"
    return lines
  end


  # Builds HTML for the provided field for a form.
  # @param [FieldsetAssociator] fsa parent FieldsetAssociator
  # @param [Field] field The Field to render
  # @param [Array] values Saved values for the field
  # @return [Array] The HTML elements for the field
  def field_form_renderer(fsa, field, values = [])
    classes  = "#{field.field_type} "
    classes += ( field.required ? 'required' : 'optional' )
    
    field_markup = ["<li class='#{classes}' id='field-input-#{field.id}'>"]
    field_markup.push "<label for='field-#{field.id}'>"
    field_markup.push "#{field.label}: "
    field_markup.push "<abbr title='required'>*</abbr>" if field.required?
    field_markup.push "</label>"
    
    attrs = { :id => "field-#{field.id}" }
    field.field_html_attributes.each{ |a| attrs.merge({ a.attribute_name.to_sym => a.value}) } if !field.field_html_attributes.empty?
    
    case field.field_type.to_sym
    when :select
      selected = populate(field,values).to_i # should return the ID of the saved or default option
      field_markup.push select_tag "fsa-#{fsa.id}[field-#{field.id}]", options_from_collection_for_select( field.options, :id, :name, selected ), attrs
      
    when :multiple_select
      attrs.merge! multiple: true
      opts = populate( field, values )
      opts = [opts] if !opts.is_a? Array
      selected = opts.map( &:to_i ) if !opts.empty? # array of option IDs, saved > default
      field_markup.push select_tag "fsa-#{fsa.id}[field-#{field.id}]", options_from_collection_for_select( field.options, :id, :name, selected ), attrs
      
    when :radio
      field_markup.push "<div id='field-#{field.id}'>"
      field.options.each do |option|
        attrs[:id] = "field-#{field.id}-#{option.name.parameterize}"
        these_attrs = attrs
        these_attrs = attrs.merge checked: true if populate(field,values).to_i.eql? option.id
        field_markup.push "<label for='#{these_attrs[:id]}'>"
        field_markup.push radio_button "fsa-#{fsa.id}", "field-#{field.id}", option.id, these_attrs
        field_markup.push "#{option.name}"
        field_markup.push "</label>"
      end
      field_markup.push "</div>"
      
    when :checkbox
      field_markup.push "<div id='field-#{field.id}'>"
      attrs[:name] = "fsa-#{fsa.id}[field-#{field.id}][]"
      opts = populate( field, values )
      checked = []
      checked = opts.map( &:to_i ) if !opts.empty? # array of option IDs, saved > default
      field.options.each do |option|
        attrs[:id] = "field-#{field.id}-#{option.name.underscore}"
        field_markup.push "<label for='#{attrs[:id]}'>"
        field_markup.push check_box_tag "#{attrs[:name]}", "#{option.id}", checked.include?(option.id), attrs
        field_markup.push "#{option.name}"
        field_markup.push "</label>"
      end
      field_markup.push "</div>"
      
    when :textfield
      attrs.merge!( {:value => populate( field, values )} )
      field_markup.push text_field "fsa-#{fsa.id}", "field-#{field.id}", attrs
      
    when :textarea
      attrs.merge! cols: '40' if !attrs.include? :cols
      attrs.merge! rows: '6' if !attrs.include? :rows
      attrs.merge! name: "fsa-#{fsa.id}[field-#{field.id}]"
      tag = "<textarea"
      attrs.each{ |att,val| tag += " #{att}=\"#{val}\"" }
      tag += ">"
      field_markup.push tag
      field_markup.push populate( field, values )
      field_markup.push "</textarea>"
      
    when :date
      date_options = {  add_month_numbers: true,
                        start_year: Time.now.year - 70 }
      setdate = populate( field, values ) # date string if saved or default
      date_options.merge! default: Time.parse( setdate ) if !setdate.empty?
      # attrs.reject!{ |k| k.eql? :id }
      field_markup.push date_select "fsa-#{fsa.id}", "field-#{field.id}", date_options, attrs
      
    when :datetime
      date_options = {  add_month_numbers: true,
                        start_year: Time.now.year - 70 }
      setdate = populate( field, values ) # datetime string if saved or default
      date_options.merge! default: Time.parse( setdate ) if !setdate.empty?
      # attrs.reject!{ |k| k.eql? :id }
      field_markup.push datetime_select "fsa-#{fsa.id}", "field-#{field.id}", date_options, attrs
      
    when :instruction
      field_markup.push "<p>#{field.label}</p>"
      
    end # case field.field_type
    
    field_markup.push "</li>"
    return field_markup
  end
  
  # Builds HTML for the provided fieldset and its children.
  # @param [FieldsetAssociator] fsa parent FieldsetAssociator
  # @param [Field] fieldset The Fieldset to render
  # @param [Hash] values Stored values for the fieldset
  # @return [Array] The HTML elements for the fieldset
  def fieldset_renderer(fsa, fieldset, values, form_type)
    lines = ["<div id='fieldset-#{fieldset.id}' class='inputs'>"]
    lines.push "<ol>"
    fieldset.children.each do |child|
      if child.is_a? DynamicFieldsets::Field then
        lines += field_renderer( fsa, child, values[child.id], form_type )
      else # child.is_a? Fieldset
        lines += fieldset_renderer( fsa, child, values, form_type )
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
    return dynamic_fieldset_renderer(fsa, "form")
  end

  # Builds HTML for a specific dynamic fieldset in a form.
  # @param [FieldsetAssociator] The fieldset associator for the dynamic fieldset to render
  # @return [String] The HTML for the entire dynamic fieldset
  def dynamic_fieldset_renderer(fsa, form_type)
    rendered_dynamic_fieldset = ""
    fieldset_renderer( fsa, fsa.fieldset, fsa.field_values, form_type ).each do |line|
      rendered_dynamic_fieldset += line + "\n"
    end
    return rendered_dynamic_fieldset.html_safe
  end
  
  # Gives precedence to saved values; returns default values if empty
  # @param [Field] field Field to populate
  # @param [String] value Possibly saved values
  # @return The saved or default value(s)
  # I know this is messy; this is what happens when we are past deadline.
  def populate(field, value)
    if value.nil? || (value.is_a?(Array) && value.empty?)
      if field.field_defaults.length == 0
        return ""
      elsif field.field_defaults.length > 1
        return field.field_defaults.collect{ |d| d[:value] }
      else 
        return field.field_defaults.first.value
      end
    else
      return value
    end
  end
  
end
