# Helper for the field_options to create valid attributes and other data used in multiple tests
module FieldOptionHelper
  # attributes for a field option
  # @returns [Hash] all attributes needed to pass validations
  def valid_attributes
    {
      :id => 1,
      :field_id => 1,
      :label => "Supervisor",
    }
  end
end
