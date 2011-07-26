module DynamicFieldsets
  # Base class for various field_options,
  # field options are used for fields with a set of answers to choose from
  # the field types that need options are select, checkbox, or radio
  #
  # @authors Scott Sampson, Jeremiah Hemphill, Ethan Pemble
  class FieldOption < ActiveRecord::Base
    #relations
    belongs_to :field
    
    #validations
    validates_presence_of :label
    validates_inclusion_of :enabled, :in => [true, false]

    # @return [Array] Scope: enabled field options
    scope :enabled, :conditions => { :enabled => true }
  end
end
