module DynamicFieldsets
  # Stores a single record's answer to a field in a fieldset
  # Fields with multiple answers should have multiple records in this model
  class FieldRecord < ActiveRecord::Base
    belongs_to :field
    belongs_to :fieldset_associator

    validates_presence_of :field, :fieldset_associator
    validates_exclusion_of :value, :in => [nil] 
  end
end
