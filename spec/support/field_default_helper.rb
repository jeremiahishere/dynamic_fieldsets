# Helper for the field_defaults to create valid attributes and other data used in multiple tests
module FieldDefaultHelper
  # attributes for a field default
  # @returns [Hash] all attributes needed to pass validations
  def valid_attributes
    {
      :id => 1,
      :field_id => 1,
      :label => "Name",
    }
  end
end
