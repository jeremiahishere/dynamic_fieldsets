module DynamicFieldsets
  # Stores a collection of fields and other fieldsets
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Fieldset < ActiveRecord::Base
    # Relations
    has_many :fieldset_associators

    # parents
    has_many :fieldset_children, :dependent => :destroy, :as => :child
    has_many :parent_fieldsets, :source => :fieldset, :foreign_key => "fieldset_id", :through => :fieldset_children, :class_name => "Fieldset"
    # children
    has_many :fieldset_children, :dependent => :destroy, :foreign_key => "fieldset_id", :class_name => "FieldsetChildren"
    has_many :child_fields, :source => :child, :through => :fieldset_children, :source_type => "Field", :class_name => "Field"
    has_many :child_fieldsets, :source => :child, :through => :fieldset_children, :source_type => "Fieldset", :class_name => "Fieldset"


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
    
    # The collected descendents of a fieldset.  This group is sorted first by order number, 
    # then alphabetically by name in the case of duplicate order numbers.
    # @return [Array] Ordered collection of descendent fields and fieldsets.
    def children
      # #$*R$)T!#$JHGH!#)J!#$(HT!@$
      # LOOK AT ME
      # 18hr4981r-ghr4-h891t4-9t134
      # this should be removed soon
      return []

      collected_children = []
      fields.reject{|f| !f.enabled}.each{ |field| collected_children.push field }
      child_fieldsets.each{ |fieldset| collected_children.push fieldset }
      return collected_children.sort_by{ |child| [child.order_num, child.name] }
    end

  end
end
