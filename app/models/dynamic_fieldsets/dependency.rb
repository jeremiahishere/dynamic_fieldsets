module DynamicFieldsets
  # Logical atom for dealing with dependency clauses
  #
  # @author John "hex" Carter

  $relationship_list = ["equals","not equals","includes","not includes","blank","not blank"]

  class Dependency < ActiveRecord::Base


    # Relations    

    belongs_to :fieldset_child
    has_many :dependency_clauses

    # Validations
    validates_presence_of :fieldset_child_id
    validates_presence_of :value
    validates_presence_of :dependency_clause_id
    validates_inclusion_of :relationship, :in => $relationship_list

    def relationship_list
      return $relationship_list
    end

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

    def evaluate(input_hash)
      input_value = input_hash[self.fieldset_child_id]
      unless input_value.nil?
        return self.process_relationship(input_value)
      else
        return false
      end
    end

  end
end
