class InformationFormsController < ApplicationController
  #include DynamicFieldsetsHelper
  # GET /information_forms
  # GET /information_forms.xml
  def index
    @information_forms = InformationForm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @information_forms }
    end
  end

  # GET /information_forms/1
  # GET /information_forms/1.xml
  def show
    @information_form = InformationForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @information_form }
    end
  end

  # GET /information_forms/new
  # GET /information_forms/new.xml
  def new
    @information_form = InformationForm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @information_form }
    end
  end

  # GET /information_forms/1/edit
  def edit
    @information_form = InformationForm.find(params[:id])
  end

  # POST /information_forms
  # POST /information_forms.xml
  def create
    @information_form = InformationForm.new(params[:information_form])

    respond_to do |format|
      if @information_form.save
        format.html { redirect_to(@information_form, :notice => 'Information form was successfully created.') }
        format.xml  { render :xml => @information_form, :status => :created, :location => @information_form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @information_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /information_forms/1
  # PUT /information_forms/1.xml
  def update
    @information_form = InformationForm.find(params[:id])

    params.keys.each do |key|
      if key.match(/^fsa-/)
        key_id = key.gsub(/^fsa-/, "")
        fsa = DynamicFieldsets::FieldsetAssociator.find_by_id(key_id)
        params[key].keys.each do |sub_key|
          if sub_key.match(/^field-/)
            sub_key_id = sub_key.gsub(/^field-/, "")
            #field = DynamicFieldsets::Field.find_by_id(sub_key_id)
            field_record = DynamicFieldsets::FieldRecord.where(:fieldset_associator_id => fsa.id, :field_id => sub_key_id).first
            if field_record.nil?
              field_record = DynamicFieldsets::FieldRecord.create(:fieldset_associator_id => fsa.id, :field_id => sub_key_id, :value => params[key][sub_key])
            else
              field_record.value = params[key][sub_key]
              field_record.save
            end
          end
        end
      end
    end


    respond_to do |format|
      if @information_form.update_attributes(params[:information_form])
        format.html { redirect_to(@information_form, :notice => 'Information form was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @information_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /information_forms/1
  # DELETE /information_forms/1.xml
  def destroy
    @information_form = InformationForm.find(params[:id])
    @information_form.destroy

    respond_to do |format|
      format.html { redirect_to(information_forms_url) }
      format.xml  { head :ok }
    end
  end
end
