class FieldsetTestModel < ::ActiveRecord::Base
  acts_as_dynamic_fieldset :child_form => {:fieldset => :information_fieldset}, :parent_form => {:fieldset => :information_fieldset}
end
