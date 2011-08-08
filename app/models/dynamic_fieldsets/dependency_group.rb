module DynamicFieldsets
  class DependencyGroup < ActiveRecord::Base
    has_many :dependency_clauses
    belongs_to :fieldset_child


    validates_presence_of :fieldset_child_id
    validates_presence_of :success_action
    validates_presence_of :failure_action
    validate :success_action_in_action_list, :failure_action_in_action_list

    # adds an error if the success action isn't in the action list
    def success_action_in_action_list
      if !self.action_list.include?(self.success_action)
        self.errors.add(:success_action, "The success action must be set to one of the provided values.")
      end
    end

    # adds an error if the failure action isn't in the action list
    def failure_action_in_action_list
      if !self.action_list.include?(self.failure_action)
        self.errors.add(:failure_action, "The failure action must be set to one of the provided values.")
      end
    end

    # @return [Array] List of allowable actions
    def action_list
      # there may need to be some sort of hierarchy for this
      # in case there are multiple dependencies on the same field
      # what happens when your dependencies return show, hide, show
      ["show", "hide", "enable", "disable"]
    end

    # Returns all fieldset children included in this dependency group
    # Not sure if it will be useful, it would probably be called in evaluate
    # I think it will be faster to just pass the input values array all the way down
    # when evaluate is called.
    #
    # @returns [Array] An array of included fieldset children ids
    def dependent_fieldset_children
      children = []
      self.dependency_clauses.each do |clause|
        clause.dependencies.each do |dep|
          children.push(dep.fieldset_child_id)
        end
      end
      return children
    end

    # Returns the success or failure action depending on what evaluate returns
    #
    # @param [Hash] A hash of fieldset_child_id:value pairs to test against
    # @return [String] The success or failure action
    def action(input_values)
      if evaluate(input_values)
        return success_action
      else
        return failure_action
      end
    end

    # Evaluates the clauses  by ANDing them together
    # Short circuit evaluation returns false as soon as possible
    #
    # @return [Boolean] True if all of the clauses are true
    def evaluate(values)
      self.dependency_clauses.each do |clause|
        if !clause.evaluate(values)
          return false
        end
      end
      return true
    end
  end
end
