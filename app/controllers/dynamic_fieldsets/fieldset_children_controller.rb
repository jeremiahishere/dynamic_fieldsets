module DynamicFieldsets
  # Controller for handling editing of fieldset children
  # Most of this is done through the fieldsets#children action
  # Dependencies are done here
  class FieldsetChildrenController < ApplicationController
    unloadable
    
    # this view doesn't exist
    def index

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
      @fieldset_child = Dynamicfieldsets::FieldsetChild.find(params[:id])

      respond_to do |format|
        if @fieldset_child.updateattributes(params[:dynamic_fieldsets_fieldset_child])
          ### WARNING THIS ISN"T GOING TO WORK ###
          # need to pull the root fieldset here instead of the immediate parent
          # this problem probably also exists on the edit view
          format.html { redirect_to(dynamic_fieldsets_fieldset_children_path(@fieldset_child.parent), :notice => "Successfully updated a child")}
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end
end
