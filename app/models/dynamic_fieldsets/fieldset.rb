module DynamicFieldsets
  # Stores a collection of fields and other fieldsets
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Fieldset < ActiveRecord::Base
    belongs_to :parent_fieldset, :class_name => "Fieldset", :foreign_key => "parent_fieldset_id"
    has_many :child_fieldsets, :class_name => "Fieldset", :foreign_key => "parent_fieldset_id"

    validates_presence_of :name
    validates_presence_of :description
    validates_presence_of :type
    validates_presence_of :order_num, :if => lambda { !self.parent_fieldset.nil? }


  end
end
