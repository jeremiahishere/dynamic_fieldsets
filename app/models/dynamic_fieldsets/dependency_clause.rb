module DynamicFieldsets
  # A clause in CNF expression for question dependencies
  #
  # @author Jeremiah Hemphill
  class DependencyClause < ActiveRecord::Base
    belongs_to :dependency_group  
    has_many :dependencies

    validates_presence_of :dependency_group_id

    # Evaluates the depdendencies in the claus by ORing them together
    # Short circuit evaluation returns true as soon as possible
    #
    # @param [Hash] input_values A hash of fieldset_child_id:value pairs to test against
    # @return [Boolean] True if one of the dependencies is true
    def evaluate(input_values)
      self.dependencies.each do |dependency|
        if dependency.evaluate
          return true
        end
      end
      return false
    end
  end
end
