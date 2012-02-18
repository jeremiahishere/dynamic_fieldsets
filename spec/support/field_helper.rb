# Helper for the field model to create valid attributes
module FieldHelper
  # this has issues with not being able to set type
  # I am manually setting it where it is needed to avoid problems
  def valid_attributes
    {
      :name => "Test field name",
      :label => "Test field label",
      :type => "textfield",
      :required => true,
      :enabled => true,
    }
  end
end
