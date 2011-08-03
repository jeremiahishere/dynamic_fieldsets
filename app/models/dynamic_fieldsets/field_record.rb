module DynamicFieldsets
  # Stores a single record's answer to a field in a fieldset
  # Fields with multiple answers should have multiple records in this model
  class FieldRecord < ActiveRecord::Base
    belongs_to :fieldset_child
    belongs_to :fieldset_associator

    validates_presence_of :fieldset_child, :fieldset_associator
    validates_exclusion_of :value, :in => [nil]
  end
  
  # @return [Field] Alias for fieldset_child.child.
  # A record can only be associated with Field children
  def field
    self.fieldset_child.child
  end
  
end
