module DynamicFieldsets
  class FieldsetAssociator < ActiveRecord::Base
    set_table_name "dynamic_fieldsets_fieldset_associators"

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
    # @params [Hash] args A hash of arguments for the scope
    # @retursn [Array] An array of fieldset associators that match the arguments
    def self.find_by_fieldset_model_parameters(args)
      fieldset = Fieldset.find_by_nkey(args[:fieldset])
      where(
        :fieldset_id => fieldset.id, 
        :fieldset_model_id => args[:fieldset_model_id], 
        :fieldset_model_type => args[:fieldset_model_type], 
        :fieldset_model_name => args[:fieldset_model_name])
    end

    # Returns a hash of field record values
    # Fun nonintuitive stuff here
    #
    # The hash keys are field ids
    # The hash values are field_record values or field_records ids depending on the field type
    # The hash values are usually strings but sometimes arrays
    # If a field that expects a single value has multiple values, it will
    # choose one to use arbitrarily
    #
    # multiple_select: [option_ids,]
    # checkbox: [option_ids,]
    # select: option_id
    # radio: option_id
    # textfield: "value"
    # textarea: "value"
    # date: "value"
    # datetime: "value"
    # instruction: "value"
    #
    # @return [Hash] A hash of field record values associated with field ids
    def field_values
      output = {}
      self.field_records.each do |record|
        fieldtype = record.fieldset_child.child.field_type
        child_id = record.fieldset_child.id
        if fieldtype == "checkbox" || fieldtype == "multiple_select"
          output[child_id] = [] unless output[child_id].is_a? Array
          # note record.id array
          output[child_id].push record.value.to_i
        elsif fieldtype == "radio" || fieldtype == "select"
          # note record.id
          output[child_id] = record.value.to_i
        else
          # note record.value
          output[child_id] = record.value
        end
      end
      return output
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
