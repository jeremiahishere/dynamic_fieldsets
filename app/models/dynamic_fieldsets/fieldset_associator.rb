module DynamicFieldsets
  class FieldsetAssociator < ActiveRecord::Base
    self.table_name = "dynamic_fieldsets_fieldset_associators"

    belongs_to :fieldset
    belongs_to :fieldset_model, :polymorphic => true
    has_many :field_records
    
    validates_presence_of :fieldset_id, :fieldset_model_id, :fieldset_model_type, :fieldset_model_name
    validate :unique_fieldset_model_name_per_polymorphic_fieldset_model

    def unique_fieldset_model_name_per_polymorphic_fieldset_model
      FieldsetAssociator.where(:fieldset_model_id => self.fieldset_model_id, :fieldset_model_type => self.fieldset_model_id, :fieldset_model_name => self.fieldset_model_name).each do |fsa|
        if fsa.id != self.id
          self.errors.add(:fieldset_model_name, "A duplicate Field Model, Field Model Name pair has been found.")
        end
      end
    end

    # Scope to find a fieldset associator based on information from the fieldset model
    #
    # Arguments
    # fieldset: The nkey of the fieldset
    # fieldset_model_id: The id of the fieldset model
    # fieldset_model_type: The class name of the fieldset model
    # fieldset_model_name: The named fieldset in the model
    #
    # Throws an error if the fieldset does not exist to help with debugging
    #
    # @params [Hash] args A hash of arguments for the scope
    # @returns [Array] An array of fieldset associators that match the arguments
    def self.find_by_fieldset_model_parameters(args)
      fieldset = Fieldset.find_by_nkey(args[:fieldset])
      throw "Fieldset not found in FieldsetAssociator.find_by_fieldset_model_parameters" if fieldset.nil?

      where(
        :fieldset_id => fieldset.id, 
        :fieldset_model_id => args[:fieldset_model_id], 
        :fieldset_model_type => args[:fieldset_model_type], 
        :fieldset_model_name => args[:fieldset_model_name])
    end

    # Returns a hash of field record values
    #
    # This version returns a tree structure for nested fieldsets
    # Could lead to all sorts of problems
    #
    # @return [Hash] A hash of field record values associated with field ids
    def field_values
      fieldset.get_values_using_fsa(self)
    end

    #  given the params, passes along to the fieldset
    def update_fieldset_records_with_form_information(fsa_params)
      fieldset.update_field_records_with_form_information(self, fsa_params)
    end

    # Record whose field matches the name and associator matches the current associator
    #
    # This will be used to get answers to questions with hard coded names
    #
    # @return [Array] the matching records
    def field_records_by_field_name(name)
      records = self.field_records.select { |record| record.fieldset_child.child.name == name }
      return records
      
      # this version uses less queries but feels less elegant
      # field = DynamicFieldsets::Field.find_by_name(name)
      # child = DynamicFieldsets::FieldsetChild.where(:child => field, :fieldset => self.fieldset).first
      # records = DynamicFieldsets::FieldRecord.where(:child => child, :associator => self)
      # return records
    end


    # OMG COMMENT
    #
    # TODO: Fill in actual comments
    #
    # @params - stuff
    # @returns - other stuff
    def dependency_child_hash
      @fieldset_child_collection = []
      look_for_dependents(self.fieldset)
  
      output = {}
      for fieldset_child in @fieldset_child_collection
        output[fieldset_child.id] = {}
        for dependency in fieldset_child.dependencies
          dependency_group = dependency.dependency_clause.dependency_group
          output[fieldset_child.id][dependency_group.id] = dependency_group.to_hash
        end
      end
      output
    end
 

    # OMG COMMENT
    #
    # TODO: Fill in actual comments
    #
    # @params - stuff
    # @returns - other stuff
    def look_for_dependents(parent_fieldset)
      for fieldset_child in parent_fieldset.fieldset_children
        if (fieldset_child.child_type == "DynamicFieldsets::Field") && (!fieldset_child.dependencies.empty?)
          @fieldset_child_collection.push(fieldset_child)
          return
        elsif (fieldset_child.child_type == "DynamicFieldsets::Field") && (fieldset_child.dependencies.empty?)
          return
        else
          look_for_dependents(fieldset_child.child)
        end
      end
    end

  end
end
