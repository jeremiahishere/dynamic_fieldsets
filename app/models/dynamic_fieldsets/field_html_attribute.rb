module DynamicFieldsets
  # Base class for various field_html_attributes,
  # an example of an html attribute is {attribute => 'class',value => 'required'}
  # Any field can have more than one html attribute
  #
  # @authors Scott Sampson, Jeremiah Hemphill, Ethan Pemble
  class FieldHtmlAttribute < ActiveRecord::Base
    self.table_name = "dynamic_fieldsets_field_html_attributes"
    #relations
    belongs_to :field
    
    #validations
    validates_presence_of :attribute_name
    validates_presence_of :value
  end
end
