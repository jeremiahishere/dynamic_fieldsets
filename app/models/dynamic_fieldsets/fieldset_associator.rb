module DynamicFieldsets
  class FieldsetAssociator < ActiveRecord::Base
    belongs_to :fieldset

    validates_presence_of :fieldset, :field_model_id, :field_model_type, :field_model_name
    validate :unique_fieldset_model_name_per_polymorphic_fieldset_model

    def unique_fieldset_model_name_per_polymorphic_fieldset_model
      FieldsetAssociator.where(:field_model_id => self.field_model_id, :field_model_type => self.field_model_id, :field_model_name => self.field_model_name).each do |fsa|
        if fsa.id != self.id
          self.errors.add(:field_model_name, "A duplicate Field Model, Field Model Name pair has been found.")
        end
      end
    end

  end
end
