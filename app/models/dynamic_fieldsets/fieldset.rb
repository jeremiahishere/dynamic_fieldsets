module DynamicFieldsets
  # Stores a collection of fields and other fieldsets
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Fieldset < ActiveRecord::Base
    set_table_name "dynamic_fieldsets_fieldsets"

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
  end
end
