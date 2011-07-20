module DynamicFieldsets
  # Stores a collection of fields and other fieldsets
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Fieldset < ActiveRecord::Base
    # Relations
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
    
    # @return [String] Haml markup for this element.
    def markup
      return "#fieldset-" + nkey
    end
    
    # Calls markup on itself, and on its field and fieldset descendents recursively.
    # @return [Array] Each line of haml markup for the fieldset.
    def collect_markup( field_values, lines = [], depth = 0 )
      padding = ""
      depth.times.each{ padding += "  " }
      lines.push( padding + markup )
      children.each{ |child| lines |= child.collect_markup( field_values, lines, depth+1 ) }
      return lines
    end
    
    randvalues = { 1=>['test'], 2=>['hello!'] }
    
    # @return [String] Entire haml markup for the fieldset.
    def render_for_view
      haml_str = ""
      collect_markup(randvalues).each{ |line| haml_str += line + "\n" }
      return haml_str
    end

  end
end
