module DynamicFieldsets
  class DependencyGroup < ActiveRecord::Base
    has_many :dependency_clauses
    belongs_to :fieldset_child

    # List of allowable actions for the group
    # Success and failure options are returned by the get_action method
    Action_list = { "show" => { :success => "show", :failure => "hide" }, "enable" => { :success => "enable", :failure => "disable" } }

    validates_presence_of :fieldset_child_id
    validates_presence_of :action
    validate :action_in_action_list

    # adds an error if the action isn't in the action list
    def action_in_action_list
      if !action_list.keys.include?(self.action)
        self.errors.add(:action, "The action must be set to one of the provided values.")
      end
    end

    # @return [Hash] The action list hash
    def action_list
      return Action_list
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

    # Parses the dependnecy_group's fieldset_child and ones inherited through dependency clause and creates a 
    # hash where the key is the dependency_group's fieldset_child and the value is an array of all fieldset
    # children dependent on this group. This is returned as a JSON object
    #
    # @returns [JSON] A hash inside a Json object
    def dependency_group_fieldset_children
      return { self.fieldset_child_id => self.dependent_fieldset_children }.to_json
    end

    # Returns the success or failure action depending on what evaluate returns
    #
    # @param [Hash] input_values A hash of fieldset_child_id:value pairs to test against
    # @return [String] The success or failure action
    def get_action(input_values)
      if evaluate(input_values)
        return Action_list[self.action][:success]
      else
        return Action_list[self.action][:failure]
      end
    end

    # Evaluates the clauses by ANDing them together
    # Short circuit evaluation returns false as soon as possible
    #
    # @param [Hash] values A hash of fieldset_child_id:value pairs to test against
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
