module DynamicFieldsets
  # Basic controller for managing fieldsets
  class FieldsetsController < ApplicationController
    unloadable
  
    # Show all record
    def index
      @fieldsets = DynamicFieldsets::Fieldset.all

      respond_to do |format|
        format.html
      end
    end
    
    # Show single record
    def show
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])

      respond_to do |format|
        format.html
      end
    end 

    # Create new record
    def new
      @fieldset = DynamicFieldsets::Fieldset.new()

      respond_to do |format|
        format.html
      end
    end
    
    # Edit existing record
    def edit
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])

      respond_to do |format|
        format.html
      end
    end
    
    # Save new record
    def create
      @fieldset = DynamicFieldsets::Fieldset.new(params[:dynamic_fieldsets_fieldset])

      respond_to do |format|
        if @fieldset.save
          format.html { redirect_to( dynamic_fieldsets_fieldset_path(@fieldset), :notice => "Successfully created a new fieldset" )}
        else
          format.html { render :action => "new" }
        end
      end
    end

    # Update existing record
    def update
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])

      respond_to do |format|
        if @fieldset.update_attributes(params[:dynamic_fieldsets_fieldset])
          format.html { redirect_to( dynamic_fieldsets_fieldset_path(@fieldset), :notice => "Successfully updated a fieldset" )}
        else
          format.html { render :action => "edit" }
        end
      end
    end

    # Destroy existing record
    def destroy
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])
      @fieldset.destroy

      respond_to do |format|
        format.html { redirect_to( dynamic_fieldsets_fieldsets_path, :notice => "Fieldset deleted successfully!" )}
      end
    end

  end
end
