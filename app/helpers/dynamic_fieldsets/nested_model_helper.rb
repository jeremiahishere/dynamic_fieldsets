module DynamicFieldsets
  module NestedModelHelper
    # returns a link with an onclick call to remove_fields using link_to_function
    def link_to_remove_fields(name, f)  
      f.hidden_field(:_destroy) + link_to_function(name, {:onclick => "remove_fields(this)"})  
    end 

    # returns a link with an onclick call to add_fields
    # the field information is rendered from a partial and stored as a string until it is needed
    def link_to_add_fields(name, f, association, method = "add_fields")  
      new_object = f.object.class.reflect_on_association(association).klass.new  
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
        render(association.to_s.singularize + "_fields", {:f => builder, :obj => new_object})  
      end  
      link_to_function(name, {:class => name.underscore.gsub(' ', '_'), :onclick => "#{method}(this, '#{association}', '#{escape_javascript(fields)}')"})
    end
  end
end
