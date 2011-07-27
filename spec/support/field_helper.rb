# Helper for the field model to create valid attributes
module FieldHelper
  # this has issues with not being able to set type
  # I am manually setting it where it is needed to avoid problems
  def valid_attributes
    {
      :fieldset_id => 1,
      :name => "Test field name",
      :label => "Test field label",
      :field_type => "textfield",
      :required => true,
      :enabled => true,
      :order_num => 1
    }
  end
end
