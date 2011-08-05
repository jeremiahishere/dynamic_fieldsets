module DynamicFieldsets
  class DependencyClause < ActiveRecord::Base
    # uncomment when dependency group gets added
    #belongs_to :dependency_group  
    has_many :dependencies

    validates_presence_of :dependency_group

    # Evaluates the depdendencies in the claus by ORing them together
    # Short circuit evaluation returns true as soon as possible
    #
    # @return [Boolean] True if one of the dependencies is true
    def evaluate
      self.dependencies.each do |dependency|
        if dependency.evaluate
          return true
        end
      end
      return false
    end
  end
end
