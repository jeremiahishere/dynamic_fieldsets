module DynamicFieldsets
  # Logical atom for dealing with dependency clauses
  #
  # @author John "hex" Carter
  class Dependency < ActiveRecord::Base
    # Relations    

    belongs_to :fieldset_child
    has_many :dependency_clauses

    # Validations
    validates_presence_of :fieldset_child_id
    validates_presence_of :value
    validates_presence_of :dependency_clause_id
    validates_inclusion_of :relationship, :in => ["equals","not equals","includes","not includes","blank","not blank"]

    def process_relationship(input_value)
      if self.relationship == "equals"
        return self.value == input_value
      elsif self.relationship == "not equals"
        return self.value != input_value
      elsif self.relationship == "includes"
        return input_value.include?(self.value)
      elsif self.relationship == "not includes"
        return !input_value.include?(self.value)
      elsif self.relationship == "blank"
        return input_value == ""
      elsif self.relationship == "not blank"
        return input_value != ""
      else
        return false
      end
    end

    def evaluate(input_hash)
      input_value = input_hash.first.last
      dependency = Dependency.find_by_fieldset_child_id(input_hash.first.first)
      return self.process_relationship(input_value)
    end

  end
end
