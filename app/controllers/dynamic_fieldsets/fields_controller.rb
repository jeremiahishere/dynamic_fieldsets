class DynamicFieldsets::FieldsController < ApplicationController
  # GET /dynamic_fieldsets/fields
  # GET /dynamic_fieldsets/fields.xml
  def index
    @dynamic_fieldsets_fields = DynamicFieldsets::Field.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dynamic_fieldsets_fields }
    end
  end

  # GET /dynamic_fieldsets/fields/1
  # GET /dynamic_fieldsets/fields/1.xml
  def show
    @dynamic_fieldsets_field = DynamicFieldsets::Field.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dynamic_fieldsets_field }
    end
  end

  # GET /dynamic_fieldsets/fields/new
  # GET /dynamic_fieldsets/fields/new.xml
  def new
    @dynamic_fieldsets_field = DynamicFieldsets::Field.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dynamic_fieldsets_field }
    end
  end

  # GET /dynamic_fieldsets/fields/1/edit
  def edit
    @dynamic_fieldsets_field = DynamicFieldsets::Field.find(params[:id])
  end

  # POST /dynamic_fieldsets/fields
  # POST /dynamic_fieldsets/fields.xml
  def create
    @dynamic_fieldsets_field = DynamicFieldsets::Field.new(params[:dynamic_fieldsets_field])

    respond_to do |format|
      if @dynamic_fieldsets_field.save
        format.html { redirect_to(@dynamic_fieldsets_field, :notice => 'Field was successfully created.') }
        format.xml  { render :xml => @dynamic_fieldsets_field, :status => :created, :location => @dynamic_fieldsets_field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dynamic_fieldsets_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dynamic_fieldsets/fields/1
  # PUT /dynamic_fieldsets/fields/1.xml
  def update
    @dynamic_fieldsets_field = DynamicFieldsets::Field.find(params[:id])

    respond_to do |format|
      if @dynamic_fieldsets_field.update_attributes(params[:dynamic_fieldsets_field])
        format.html { redirect_to(@dynamic_fieldsets_field, :notice => 'Field was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dynamic_fieldsets_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dynamic_fieldsets/fields/1
  # DELETE /dynamic_fieldsets/fields/1.xml
  def destroy
    @dynamic_fieldsets_field = DynamicFieldsets::Field.find(params[:id])
    @dynamic_fieldsets_field.destroy

    respond_to do |format|
      format.html { redirect_to(dynamic_fieldsets_fields_url) }
      format.xml  { head :ok }
    end
  end
end
