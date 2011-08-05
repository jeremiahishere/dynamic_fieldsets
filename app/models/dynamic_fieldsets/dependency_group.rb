module DynamicFieldsets
  class DependencyGroup < ActiveRecord::Base
    has_many :dependency_clauses
    #belongs_to :fieldset_child

    # just guessing on these validations
    #validates_presence_of :fieldset_child
    #validates_presence_of :success_action
    #validates_presence_of :failure_action

    # Evaluates the clauses  by ANDing them together
    # Short circuit evaluation returns false as soon as possible
    #
    # @return [Boolean] True if all of the clauses are true
    def evaluate
      self.dependency_clauses.each do |clause|
        if !clause.evaluate
          return false
        end
      end
      return true
    end
  end
end
