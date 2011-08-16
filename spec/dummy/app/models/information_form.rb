class InformationForm < ActiveRecord::Base
  acts_as_dynamic_fieldset :child_form => {:fieldset => :first}, :parent_form => {:fieldset => :first}
end
