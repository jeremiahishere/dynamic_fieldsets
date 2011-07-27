module NavigationHelpers

  def path_to(page_name)
    case page_name

    when /^the fieldset associator index page$/
      "/dynamic_fieldsets/fieldset_associators/"
    when /^the fieldset associator show page for that fieldset associator$/
      "/dynamic_fieldsets/fieldset_associators/" + DynamicFieldsets::FieldsetAssociator.last.id.to_s

    when /^the fieldset index page$/
      "/dynamic_fieldsets/fieldsets"
    when /^the fieldset new page$/
      "/dynamic_fieldsets/fieldsets/new"
    when /^the fieldset edit page for that fieldset$/
      "/dynamic_fieldsets/fieldsets/" + DynamicFieldsets::Fieldset.last.id.to_s + "/edit"
    when /^the fieldset show page for that fieldset$/
      "/dynamic_fieldsets/fieldsets/" + DynamicFieldsets::Fieldset.last.id.to_s

    when /^the field index page$/
      "/dynamic_fieldsets/fields"
    when /^the field new page$/
      "/dynamic_fieldsets/fields/new"
    when /^the field edit page for that field$/
      "/dynamic_fieldsets/fields/" + DynamicFieldsets::Field.last.id.to_s + "/edit"
    when /^the field show page for that field$/
      "/dynamic_fieldsets/fields/" + DynamicFieldsets::Field.last.id.to_s

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
