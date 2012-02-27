module DynamicFieldsets
  # Stores a single record's answer to a field in a fieldset
  # Fields with multiple answers should have multiple records in this model
  class FieldRecord < ActiveRecord::Base
    self.table_name = "dynamic_fieldsets_field_records"

    belongs_to :fieldset_child
    belongs_to :fieldset_associator

    validates_presence_of :fieldset_child, :fieldset_associator
    validates_exclusion_of :value, :in => [nil]
    validate :type_of_fieldset_child

    # make sure the fieldset child has the type field
    # does not explicitly check to make sure the fieldset_child exists, still have to validate presence
    def type_of_fieldset_child
      if self.fieldset_child && !self.fieldset_child.child.is_a?(DynamicFieldsets::Field)
        self.errors.add(:fieldset_child, "The fieldset child must refer to a Field object")
      end
    end
  
    # @return [Field] Alias for fieldset_child.child.
    # A record can only be associated with Field children
    def field
      self.fieldset_child.child
    end
  end  
end
