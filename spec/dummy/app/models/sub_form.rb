class SubForm < ActiveRecord::Base
  belongs_to :information_form

  acts_as_dynamic_fieldset :child_form3 => {:fieldset => :third, :initialize_on_create => true}
end
