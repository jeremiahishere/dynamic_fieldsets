module DynamicFieldsets

  # Logical atom for dealing with dependency clauses
  #
  # @author John "hex" Carter
  class Dependency < ActiveRecord::Base

    RELATIONSHIP_LIST = ["equals","not equals","includes","not includes","blank","not blank"]

    # Relations    

    belongs_to :fieldset_child
    belongs_to :dependency_clause

    # Validations
    validates_presence_of :fieldset_child_id
    validates_presence_of :value
    validates_presence_of :dependency_clause_id
    validates_inclusion_of :relationship, :in => RELATIONSHIP_LIST

    # Returns a full list of the options for relationship_list
    #
    # @params [None]
    # @returns [Array] The array of the constant RELATIONSHIP_LIST
    #
    def relationship_list
      return RELATIONSHIP_LIST
    end

    # Returns true or false based on whether the value pushed in matches the logical relationship between it and the dependency's value 
    #
    # @params [String] input_value - The value to be tested
    # @returns [Boolean] Logical response to relationship between the dependency value and the pushed value
    #
    def process_relationship(input_value)
      case self.relationship
      when "equals" 
        return self.value == input_value
      when "not equals"
        return self.value != input_value
      when "includes"
        return input_value.include?(self.value)
      when "not includes"
        return !input_value.include?(self.value)
      when "blank"
        return input_value == ""
      when "not blank"
        return input_value != ""
      else
        return false
      end
    end

    # Looks through the input_hash for the fieldset_child that matches the one belonging to this dependency and compares the values through process_relationship
    #
    # @params [Hash] input_hash - Key is the id of the fieldset_child to be tested, value is the input given by the user
    # @returns [Boolean] returns the value of process_relationship unless the input doesn't contain the fieldset_child of the dependency, which also returns false 
    #
    def evaluate(input_hash)
      input_value = input_hash[self.fieldset_child_id]
      unless input_value.nil?
        return self.process_relationship(input_value)
      else
        return false
      end
    end

    def to_hash
      return { "id" => self.id, "fieldset_child_id" => self.fieldset_child_id, "value" => self.value, "relationship" => self.relationship, "dependency_clause_id" => self.dependency_clause_id }
    end
  end
end
