module DynamicFieldsets
  class FieldsController < ApplicationController
    include FieldsHelper

    # GET /dynamic_fieldsets/fields
    def index
      @fields = DynamicFieldsets::Field.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end

    # GET /dynamic_fieldsets/fields/1
    def show
      @field = DynamicFieldsets::Field.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
      end
    end

    # GET /dynamic_fieldsets/fields/new
    def new
      @field = DynamicFieldsets::Field.new

      respond_to do |format|
        format.html # new.html.erb
      end
    end

    # GET /dynamic_fieldsets/fields/1/edit
    def edit
      @field = DynamicFieldsets::Field.find(params[:id])
    end

    # Custom controller action to set the enabled field on the field object
    # Expects a url with an id field and a form with the value [:dynamic_fieldsets_field][:enabled]
    # On success or failure, redirects to the index page with a notice
    #
    # This should never fail the save unless the field was initially saved without validations
    def enable
      @field = DynamicFieldsets::Field.find(params[:id])
      @field.enabled = params[:dynamic_fieldsets_field][:enabled]
      respond_to do |format|
        if @field.save
          format.html { redirect_to(dynamic_fieldsets_fields_path, :notice => 'Successfully updated a new field.') }
        else
          format.html { redirect_to(dynamic_fieldsets_fields_path, :notice => 'Did not update the field successfully.') }
        end
      end
    end

    # POST /dynamic_fieldsets/fields
    def create
      parent_id = params[:parent]
      @field = params[:dynamic_fieldsets_field][:type].constantize.new(params[:dynamic_fieldsets_field])

      respond_to do |format|
        
        if @field.save
          if !parent_id.empty?
            parent = DynamicFieldsets::Fieldset.find_by_id(parent_id)
            DynamicFieldsets::FieldsetChild.create( :fieldset => parent, :child => @field )
            #relation = @fieldset.fieldset_children.build( :fieldset => parent )
            #relation.child = @field
            #relation.save
          end
          format.html { redirect_to(dynamic_fieldsets_field_path(@field), :notice => 'Successfully created a new field.') }
        else
          format.html { render :action => "new" }
        end
      end
    end

    # PUT /dynamic_fieldsets/fields/1
    def update
      # note that on update, we need to get a Field object so that the type can be changed
      @field = DynamicFieldsets::Field.find(params[:id])

      respond_to do |format|
        # this is sort of a bad hack to make field type changes work
        # it is setup to allow validations to stop the type from changing using validations
        # this could be improved by figuring out how to set the type using update_attributes (JH 3-2-2012)
        if @field.type != params[:dynamic_fieldsets_field][:type]
          @field.type = params[:dynamic_fieldsets_field][:type]
          if @field.save
            @field = DynamicFieldsets::Field.find(params[:id])
          else
            format.html { render :action => "edit", :notice => 'Could not change the field type.' }
          end
        end
        
        if @field.update_attributes(params[:dynamic_fieldsets_field])
          format.html { redirect_to(dynamic_fieldsets_field_path(@field), :notice => 'Successfully updated a field.') }
        else
          format.html { render :action => "edit" }
        end
      end
    end

    # DELETE /dynamic_fieldsets/fields/1
    # DELETE /dynamic_fieldsets/fields/1.xml
    def destroy
      @field = DynamicFieldsets::Field.find(params[:id])
      @field.destroy

      respond_to do |format|
        format.html { redirect_to(dynamic_fieldsets_fields_url) }
      end
    end
  end
end
