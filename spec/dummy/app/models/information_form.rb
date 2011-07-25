class InformationForm < ActiveRecord::Base
  multipart_formable :child_form => {:fieldset => :information_fieldset}, :parent_form => {:fieldset => :information_fieldset}
end
