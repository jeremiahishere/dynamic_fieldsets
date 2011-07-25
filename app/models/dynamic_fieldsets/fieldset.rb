module DynamicFieldsets
  # Stores a collection of fields and other fieldsets
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Fieldset < ActiveRecord::Base
    # Relations
    has_many :fieldset_associators
    belongs_to :parent_fieldset, :class_name => "Fieldset", :foreign_key => "parent_fieldset_id"
    has_many :child_fieldsets, :class_name => "Fieldset", :foreign_key => "parent_fieldset_id"
    has_many :fields

    # Validations
    validates_presence_of :name
    validates_presence_of :description
    validates_presence_of :nkey
    validates_presence_of :order_num, :if => lambda { !self.root? }
    
    # @return [Array] Scope: parent-less fieldsets
    scope :roots, :conditions => ["parent_fieldset_id IS NULL"]

    # @return [Boolean] True if fieldset has no parent
    def root?
      return parent_fieldset.nil?
    end
    
    # The collected descendents of a fieldset.  This group is sorted first by order number, 
    # then alphabetically by name in the case of duplicate order numbers.
    # @return [Array] Ordered collection of descendent fields and fieldsets.
    def children
      collected_children = []
      fields.each{ |field| collected_children.push field }
      child_fieldsets.each{ |fieldset| collected_children.push fieldset }
      return collected_children.sort_by{ |child| [child.order_num, child.name] }
    end

  end
end
