module DynamicFieldsets
  class FieldsetChild < ActiveRecord::Base
    belongs_to :child, :polymorphic => true
    belongs_to :fieldset
    
    has_many :field_records
    has_one :dependency_group

    validates_presence_of :fieldset_id
    validates_presence_of :child_id
    validates_presence_of :child_type
    validates_presence_of :order_num
    validate :no_duplicate_fields_in_fieldset_children
    validate :cannot_be_own_parent
    validate :no_parental_loop

    #TODO - validate that child_type only be "field" or "fieldset"

    def no_duplicate_fields_in_fieldset_children
      if self.fieldset && self.child
        duplicate_children = FieldsetChild.where(:fieldset_id => self.fieldset.id, :child_id => self.child_id, :child_type => self.child_type).select { |fieldset_child| fieldset_child.id != self.id }
        if duplicate_children.length > 0
          self.errors.add(:child_id, "There is already a copy of this child in the fieldset.")
        end
      end
    end

    def cannot_be_own_parent
      if self.child_type == "DynamicFieldsets::Fieldset"
        if self.fieldset_id == self.child_id
          self.errors.add(:child_id, "A fieldset cannot have itself as a parent.")
        end
      end
    end

    def no_parental_loop
      if (self.child_type == "DynamicFieldsets::Fieldset") && (self.has_loop?([self.fieldset_id]))
        self.errors.add(:child_id, "There is a fieldset that contains itself as a parent.")
      end
    end

    def has_loop?(parent_array)
      return true if parent_array.include? self.child_id
      parent_array.push self.child_id
      return true if FieldsetChild.where(:fieldset_id => self.child_id).find { |f| f.has_loop? parent_array }
      parent_array.pop
      return false
    end
  end
end
