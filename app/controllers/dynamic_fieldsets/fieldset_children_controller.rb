module DynamicFieldsets
  # Controller for handling editing of fieldset children
  # Most of this is done through the fieldsets#children action
  # Dependencies are done here
  class FieldsetChildrenController < ApplicationController
    
    # this view doesn't exist
    def index
    end

    # Show a record and all children
    def show
      @fieldset_child = DynamicFieldsets::FieldsetChild.find params[:id]
      @fieldset = DynamicFieldsets::Fieldset.find @fieldset_child.fieldset_id

      respond_to do |format|
        format.html
      end
    end

    def edit
      @fieldset_child = DynamicFieldsets::FieldsetChild.find(params[:id])
      respond_to do |format|
        format.html
      end
    end

    # updates the fieldset_child and uses accepts_nested_attributes_for to setup a dependency system
    def update
      @fieldset_child = DynamicFieldsets::FieldsetChild.find(params[:id])

      respond_to do |format|
        if @fieldset_child.update_attributes(params[:dynamic_fieldsets_fieldset_child])
          format.html { redirect_to(dynamic_fieldsets_children_dynamic_fieldsets_fieldset_path(@fieldset_child.root_fieldset), :notice => "Successfully updated a child")}
        else
          format.html { render :action => "edit" }
        end
      end
    end

    # deletes the fieldset child and redirects to its root fieldset page
    def remove
      @fieldset_child = DynamicFieldsets::FieldsetChild.find(params[:id])
      root = @fieldset_child.root_fieldset

      respond_to do |format|  
        if @fieldset_child.destroy
          notice_text = "Successfully removed the child"
        else
          notice_text = "Child was not able to be removed"
        end
        format.html { redirect_to(dynamic_fieldsets_children_dynamic_fieldsets_fieldset_path(root), :notice => notice_text)}
      end
    end
  end
end
