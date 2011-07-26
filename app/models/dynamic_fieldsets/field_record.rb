# add relationships to field and fieldset_associator
#

module DynamicFieldsets
  class FieldRecord < ActiveRecord::Base
    belongs_to :field
    belongs_to :fieldset_associator

    validates_presence_of :field, :fieldset_associator
    validates_exclusion_of :value, :in => [nil] 
  end
end
