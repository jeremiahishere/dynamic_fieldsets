# Helper for the field record model
module FieldRecordHelper
  # attributes for the field reocrd that should pass validations
  # @returns [Hash] All attributes needed to pass validations
  def valid_attributes
    {
      :field_id => 1,
      :fieldset_associator_id => 1,
      :value => "forty two"
    }
  end
end
