module DynamicFieldsets
  # ...
  class FieldsetChildrenController < ApplicationController
    unloadable
    
    # Show a record and all children
    def show
      @fieldset_child = DynamicFieldsets::FieldsetChild.find_by_id params[:id]
      @fieldset = DynamicFieldsets::Fieldset.find_by_id @fieldset_child.fieldset_id

      respond_to do |format|
        format.html
      end
    end
    
  end
end