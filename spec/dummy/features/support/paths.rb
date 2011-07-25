module NavigationHelpers

  def path_to(page_name)
    case page_name

    when /^the fieldset associator index page$/
      "/dynamic_fieldsets/fieldset_associators/"
    when /^the fieldset associator show page for that fieldset associator$/
      "/dynamic_fieldsets/fieldset_associators/" + DynamicFieldsets::FieldsetAssociator.last.id.to_s

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
