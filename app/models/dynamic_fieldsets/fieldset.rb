module DynamicFieldsets
  # Stores a collection of fields and other fieldsets
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Fieldset < ActiveRecord::Base
    # Relations
    belongs_to :parent_fieldset, :class_name => "Fieldset", :foreign_key => "child_fieldset_id"
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
    
    # Calls get_markup on itself, and on its field and fieldset descendents recursively.
    # @return [Array] Each line of haml markup for the fieldset.
    def full_markup( lines = [], depth = 0 )
      padding = ""
      depth.times.each{ padding += "  " }
      lines.push( padding + get_markup )
      fields.each{ |field| lines.push( padding + "  " + field.get_markup ) }
      child_fieldsets.each{ |fieldset| fieldset.full_markup( lines, depth+1 ) }
      return lines if depth == 0
    end
    
    # @return [String] Entire haml markup for the fieldset.
    def render_for_view
      haml_str = ""
      full_markup.each{ |line| haml_str += line + "\n" }
      return haml_str
    end
    
    # @return [String] Haml markup for this element.
    def get_markup
      return "#fieldset-" + nkey
    end
    
    # ...
    def get_ordered_children
      return nil
    end

  end
end
