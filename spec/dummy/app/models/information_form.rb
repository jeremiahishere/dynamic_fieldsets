class InformationForm < ActiveRecord::Base
  # important note: for this to work, there needs to have a fieldset with an nkey of "first" in the db
  # so that DynamicFieldsets::Fieldset.find_by_nkey("first") returns a fieldset
  acts_as_dynamic_fieldset :child_form => {:fieldset => :first, :initialize_on_create => true}
  acts_as_dynamic_fieldset :child_form2 => {:fieldset => :second, :initialize_on_create => true}
end
