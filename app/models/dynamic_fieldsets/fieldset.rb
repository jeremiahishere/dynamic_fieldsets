module DynamicFieldsets
  # Stores a collection of fields and other fieldsets
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Fieldset < ActiveRecord::Base
    # Relations
    has_many :fieldset_associators

    # parents
    has_many :fieldset_parents, :dependent => :destroy, :class_name => "FieldsetChild", :as => :child
    has_many :parent_fieldsets, :source => :fieldset, :foreign_key => "fieldset_id", :through => :fieldset_parents, :class_name => "DynamicFieldsets::Fieldset"
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
      all.select { |fs| fs.parent_fieldsets.empty? }
    end
    
    # @return [Array] An array of name, id pairs to be used in select tags
    def self.parent_fieldset_list
      all.collect { |f| [f.name, f.id] }
    end

    # @return [Boolean] True if fieldset has no parent
    def root?
      return parent_fieldset.nil?
    end
    
    # The collected descendents of a fieldset.  
    # This group is sorted by order number on the fieldsetchild model 
    # @return [Array] Ordered collection of descendent fields and fieldsets.
    def children
      collected_children = []
      self.fieldset_children.sort_by{ |child| child.order_num }.each do |child|
        child_obj = child.child_type.constantize.find_by_id(child.child_id)
        if child_obj.respond_to?(:enabled?)
          if child_obj.enabled?
            collected_children.push child_obj
          end
        else
          collected_children.push child_obj
        end
      end
      return collected_children
    end

  end
end
