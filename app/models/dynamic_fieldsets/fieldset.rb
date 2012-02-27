module DynamicFieldsets
  # Stores a collection of fields and other fieldsets
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Fieldset < ActiveRecord::Base
    self.table_name = "dynamic_fieldsets_fieldsets"

    # Relations
    has_many :fieldset_associators

    # parents
    has_one :fieldset_parent, :dependent => :destroy, :class_name => "FieldsetChild", :as => :child
    has_one :parent, :source => :fieldset, :foreign_key => "fieldset_id", :through => :fieldset_parent, :class_name => "DynamicFieldsets::Fieldset"
    # children
    has_many :fieldset_children, :dependent => :destroy, :foreign_key => "fieldset_id", :class_name => "FieldsetChild"
    has_many :child_fields, :source => :child, :through => :fieldset_children, :source_type => "DynamicFieldsets::Field", :class_name => "DynamicFieldsets::Field"
    has_many :child_fieldsets, :source => :child, :through => :fieldset_children, :source_type => "DynamicFieldsets::Fieldset", :class_name => "DynamicFieldsets::Fieldset"


    # Validations
    validates_presence_of :name
    validates_presence_of :description
    validates_presence_of :nkey
    validates_uniqueness_of :nkey
    
    # @return [Array] Scope: parent-less fieldsets
    def self.roots
      # the old method used a scope and the old table definition
      # scope :roots, :conditions => ["parent_fieldset_id IS NULL"]
      # the new method doesn't use a scope because I am bad at them
      all.select { |fs| fs.parent.nil? }
    end

    # @return [Boolean] True if fieldset has no parent
    def root?
      return parent.nil?
    end
    
    # @return [Array] An array of name, id pairs to be used in select tags
    def self.parent_fieldset_list
      all.collect { |f| [f.name, f.id] }
    end
    
    # The collected descendents of a fieldset.
    # This group is sorted by order number on the fieldsetchild model 
    # 
    # IMPORTANT NOTE: At first glance, this looks like it should return a collection of fieldset children.  It does not.
    # This is a relic from the original design, and there is code working around the issue in several different places.
    #
    # @return [Array] Ordered collection of descendent fields and fieldsets.
    def children
      collected_children = []
      self.fieldset_children.sort_by(&:order_num).each do |fs_child|
        child = fs_child.child_type.constantize.find_by_id fs_child.child_id
        if child.respond_to? :enabled? and child.enabled?
          collected_children.push child
        elsif !child.respond_to? :enabled?
          collected_children.push child
        end
      end
      return collected_children
    end
    
    def has_children?
      return !self.fieldset_children.empty?
    end

    # returns field record values for every field in the fsa
    #
    # note that this adds a hierarchy to the values
    # not sure if this will require a rewrite somewhere else
    #
    # @param [DynamicFieldsets::FieldsetAssociator] The parent fsa
    # @return [Hash] A hash of field record values using the fieldset child id as they key
    def get_values_using_fsa(fsa)
      output = {}
      fieldset_children.each do |child|
        output[child.id] = child.get_value_using_fsa(fsa)
      end      
      return output
    end

    # Updates field options based on information from the form
    #
    # The form values should only be values for the current fsa
    #
    # @param [Hash] form_values Information from the form
    def update_field_records_with_form_information(form_values)
      form_values.each_pair do |fieldset_child_key, value|
        if fieldset_child_key.start_with?(DynamicFieldsets.config.form_field_prefix)
          fieldset_child_id = fieldset_child_key.gsub(/^#{DynamicFieldsets.config.form_field_prefix}/, "")
          fieldset_child = fieldset_children.select { |child| child.id == fieldset_child_id.to_i }.first
          # this could potentially hit a fieldset and cause problems
          fieldset_child.child.update_field_records(self, fieldset_child, value)
        end
      end
    end
  end
end
