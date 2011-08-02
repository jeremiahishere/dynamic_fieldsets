module DynamicFieldsets
  class FieldsetChild < ActiveRecord::Base
    belongs_to :child, :polymorphic => true
    belongs_to :fieldset

    validates_presence_of :fieldset_id
    validates_presence_of :child_id
    validates_presence_of :child_type
    validates_presence_of :order_num
    validate :no_duplicate_fields_in_fieldset_children

    def no_duplicate_fields_in_fieldset_children
      if self.fieldset && self.child
        duplicate_children = FieldsetChild.where(:fieldset_id => self.fieldset.id, :child_id => self.child_id, :child_type => self.child_type).select { |child| child.id != self.id }
        if duplicate_children > 0
          self.errors.add(:child, "There is already a copy of this child in the fieldset.")
        end
      end
    end
  end
end
