# Helper for the fieldset to create valid attributes and other data used in multiple tests
module FieldsetHelper
  # attributes for a top level fieldset with no parent
  # @returns [Hash] all attributes needed to pass validations
  def valid_top_level_attributes
    {
      :name => "Hire Form",
      :description => "Hire a person for a job",
      :nkey => "hire_form"
    }
  end

  # attributes for a child fieldset with a parent
  # the parent_fieldset may be wrong
  # @returns [Hash] all attributes needed to pass validations
  def valid_child_attributes
    {
      :name => "Hire Form",
      :description => "Hire a person for a job",
      :nkey => "hire_form",
      :order_num => 1,
    }
      # this should be in there but isnt working right now
      #:parent_fieldset => DynamicFieldset::Fieldset.new
  end
end
