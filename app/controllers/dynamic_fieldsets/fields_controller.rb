module DynamicFieldsets
  class FieldsController < ApplicationController
    include FieldsHelper
    unloadable

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

      unless params[:parent].nil?
        @parent = DynamicFieldsets::Field.find(params[:parent])
      end

      respond_to do |format|
        format.html # new.html.erb
      end
    end

    # GET /dynamic_fieldsets/fields/1/edit
    def edit
      @field = DynamicFieldsets::Field.find(params[:id])
    end

    # POST /dynamic_fieldsets/fields
    def create
      @field = DynamicFieldsets::Field.new(params[:dynamic_fieldsets_field])

      respond_to do |format|
        if @field.save
          format.html { redirect_to(@field, :notice => 'Successfully created a new field.') }
        else
          format.html { render :action => "new" }
        end
      end
    end

    # PUT /dynamic_fieldsets/fields/1
    def update
      @field = DynamicFieldsets::Field.find(params[:id])

      respond_to do |format|
        if @field.update_attributes(params[:dynamic_fieldsets_field])
          format.html { redirect_to(@field, :notice => 'Successfully updated a field.') }
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
