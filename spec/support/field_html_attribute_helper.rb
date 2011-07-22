# Helper for the fieldset to create valid attributes and other data used in multiple tests
module FieldHtmlAttributeHelper
  # attributes for a html attribute
  # @returns [Hash] all attributes needed to pass validations
  def valid_attributes
    {
      :id => 1,
      :field_id => 1,
      :attribute_name => "class",
      :value => "on"
    }
  end

end
