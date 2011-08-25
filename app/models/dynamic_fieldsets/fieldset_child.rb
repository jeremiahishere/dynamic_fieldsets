module DynamicFieldsets

  # FieldsetChild
  # @author Jeremiah Hemphill, John "hex" Carter
  class FieldsetChild < ActiveRecord::Base

    # Constants

    FIELDSET_CHILD_LIST = ["DynamicFieldsets::Field", "DynamicFieldsets::Fieldset"]

    # Relationships

    belongs_to :child, :polymorphic => true
    belongs_to :fieldset
    
    has_many :field_records

    # this is a little confusing, so let's explain:
    # a fieldset_child can have many dependencies when it is a part of several dependencies
    # which each belong to a dependency_clause, which consequently belongs to a dependency_group.
    # a fieldset_child belongs to a dependency_group when it is at the END of a dependency_clause
    # statement:
    #   IF Field1 == A AND Field2 == B THEN show Field3
    # In that example, Field1 and Field2 belong to dependencies and Field3 belongs to a dependency_group
    has_one :dependency_group
    accepts_nested_attributes_for :dependency_group, :allow_destroy => true

    has_many :dependencies

    # Validations

    validates_presence_of :fieldset_id
    validates_presence_of :child_id
    validates_inclusion_of :child_type, :in => FIELDSET_CHILD_LIST
    validates_presence_of :order_num
    validate :no_duplicate_fields_in_fieldset_children
    validate :cannot_be_own_parent
    validate :no_parental_loop
    
    before_validation :assign_order
    
    # This method is called when FieldsetChildren is instantiated. 
    # It ensures that the Child has a valid order number.
    def assign_order
      self.order_num = self.last_order_num + 1 if self.order_num.nil?
    end

    # Methods

    # Returns a list of all the values in the FIELDSET_CHILD_LIST constant
    #
    # @params [None]
    # @returns [Array] An array of all the values stored in FIELDSET_CHILD_LIST
    def fieldset_child_list
      return FIELDSET_CHILD_LIST
    end

    # Sends a validation error if there are any duplicate pairings of fieldsets and fieldset children.
    # 
    # @params [None]
    # @returns [Errors] In the case a duplicate pairing fieldsets and fieldset children are found, it returns a validation error.
    def no_duplicate_fields_in_fieldset_children
      if self.fieldset && self.child
        duplicate_children = FieldsetChild.where(:fieldset_id => self.fieldset.id, :child_id => self.child_id, :child_type => self.child_type).select { |fieldset_child| fieldset_child.id != self.id }
        if duplicate_children.length > 0
          self.errors.add(:child_id, "There is already a copy of this child in the fieldset.")
        end
      end
    end

    # Sends a validation error if there is an attempt to save a fieldset as its own parent.
    #
    # @params [None]
    # @returns [Errors] In the case a fieldset is its own parent a validation error is returned.
    def cannot_be_own_parent
      if self.child_type == "DynamicFieldsets::Fieldset"
        if self.fieldset_id == self.child_id
          self.errors.add(:child_id, "A fieldset cannot have itself as a parent.")
        end
      end
    end

    # Recursively looks to see if there is an attempt to save a fieldset as a descendent of itself
    #
    # @params [None]
    # @returns [Errors] In the case a fieldset contains itself as a parent, a validation error is returned.
    def no_parental_loop
      if (self.child_type == "DynamicFieldsets::Fieldset") && (self.has_loop?([self.fieldset_id]))
        self.errors.add(:child_id, "There is a fieldset that contains itself as a parent.")
      end
    end

    # Recursively calls itself to span entire hierarchy of a fieldset child family to see if any attempts to have a parental loop exist
    #
    # @params [Array] parent_array - A collection of all previously checked parents. If a repeat parent is found, it returns false, else true.
    # @returns [Boolean] If there are no parental loops, it returns true, else it returns true
    def has_loop?(parent_array)
      return true if parent_array.include? self.child_id
      parent_array.push self.child_id
      return true if FieldsetChild.where(:fieldset_id => self.child_id).find { |f| f.has_loop? parent_array }
      parent_array.pop
      return false
    end
    
    # scope for ascending order
    def self.ordered
      order 'order_num asc'
    end
    
    # @return [Array] Collection of FieldsetChildren that share the same parent; ascending order.
    def siblings
      sib = FieldsetChild.where( fieldset_id: self.fieldset_id ).ordered
      sib.delete self
      sib
    end
    
    # @return [Integer] The order number of the last sibling.
    def last_order_num
      return 0 if siblings.empty?
      return self.siblings.last[:order_num]
    end
    

    def to_hash
      return { "id" => self.id, "fieldset_id" => self.fieldset_id, "child_id" => self.child_id, "child_type" => self.child_type }
    end

    # Returns the root fieldset of the child
    # Loops up the parent fieldset field until the parent is nil, then returns the child
    #
    # Important: This method is dependent on fieldsets not being reusable
    #
    # @return [Fieldset] The root fieldset of the fieldsetchild
    def root_fieldset(fs = self.fieldset)
      # whether the parent is a child
      parent_as_a_child = FieldsetChild.where(:child_id => fs.id, :child_type => "DynamicFieldsets::Fieldset")
      # my parent is nobody's child, it is the root
      if parent_as_a_child.count == 0
        return fs
      else # if my parent is someone else's child, then
        # look at her parent
        return root_fieldset(parent_as_a_child.first.fieldset)
      end
    end
  end
end
