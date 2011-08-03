# Helper for the fieldset to create valid attributes and other data used in multiple tests
module FieldsetHelper
  # attributes for a fieldset
  # @returns [Hash] all attributes needed to pass validations
  def valid_attributes
    {
      :name => "Hire Form",
      :description => "Hire a person for a job",
      :nkey => "hire_form"
    }
  end
end
