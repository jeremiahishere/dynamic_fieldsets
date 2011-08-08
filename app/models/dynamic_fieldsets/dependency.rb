module DynamicFieldsets
  # Logical atom for dealing with dependency clauses
  #
  # @author John "hex" Carter
  class Dependency < ActiveRecord::Base
    # Relations    

    # Validations
    validates_presence_of :field_id
    validates_presence_of :value
    validates_presence_of :relationship
    validates_presence_of :dependency_clause_id

  end
end
