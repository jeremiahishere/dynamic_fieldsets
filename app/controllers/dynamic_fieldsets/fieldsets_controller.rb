module DynamicFieldsets
  # Basic controller for managing fieldsets
  class FieldsetsController < ApplicationController
    unloadable
  
    # Show all fieldsets
    def index
      @fieldsets = DynamicFieldsets::Fieldset.all

      respond_to do |format|
        format.html
      end
    end
    
    # Show all root fieldsets
    def roots
      @fieldsets = DynamicFieldsets::Fieldset.roots

      respond_to do |format|
        format.html { render action: 'index' }
      end
    end
    
    # Show single fieldset
    def show
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])

      respond_to do |format|
        format.html
      end
    end 

    # Create new fieldset
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

    # Show a record and all children
    def children
      @fieldset = DynamicFieldsets::Fieldset.find_by_id params[:id]

      respond_to do |format|
        format.html
      end
    end
    
    # Save new record
    def create
      parent_id = params[:parent]
      @fieldset = DynamicFieldsets::Fieldset.new(params[:dynamic_fieldsets_fieldset])

      respond_to do |format|
        if @fieldset.save
          if !parent_id.empty?
            parent = DynamicFieldsets::Fieldset.find_by_id(parent_id)
            DynamicFieldsets::FieldsetChild.create( :fieldset => parent, :child => @fieldset )
            #relation = @fieldset.fieldset_children.build( :fieldset => parent )
            #relation.child = @fieldset
            #relation.save
          end
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
