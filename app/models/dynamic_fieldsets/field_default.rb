module DynamicFieldsets
  # Base class for various field_defaults,
  # A text field would have a single default value
  # While a multiple select could have multiple default values
  #
  # @authors Scott Sampson, Jeremiah Hemphill, Ethan Pemble
  class FieldDefault < ActiveRecord::Base
    #relations
    belongs_to :field
    
    #validations
    validates_presence_of :value
  end
end