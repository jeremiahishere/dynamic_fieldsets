require 'spec_helper'
include DynamicFieldsets

describe DynamicFieldsetsHelper do
  include DynamicFieldsetsHelper
  include FieldsetHelper
  describe ".dynamic_fieldset_renderer" do
    before(:each) do
      @fsa = mock_model(FieldsetAssociator)
      @fsa.stub!(:fieldset).and_return mock_model(Fieldset)
      @fsa.stub!(:field_values).and_return []
      stub!(:fieldset_renderer).and_return []
    end

    it "should include a form object and a field set associator object" do
      lambda { dynamic_fieldset_renderer(@fsa, "form") }.should_not raise_error
    end

    it "should call the fieldset_renderer with the fsa's root fieldset" do
      @fsa.should_receive(:fieldset)
      dynamic_fieldset_renderer(@fsa, "form")
    end

    it "should return a string of html" do
      dynamic_fieldset_renderer(@fsa, "form").should be_a_kind_of String
    end
  end

  describe "dynamic_fieldset_form_renderer" do
    it "needs tests"
  end

  describe "dynamic_fieldset_show_renderer" do
    it "needs tests"
  end

  describe ".fieldset_renderer" do
    before(:each) do
      @fsa = mock_model(FieldsetAssociator)
      @fieldset = Fieldset.new
      @fieldset.stub!(:id).and_return 326
      @values = {}
      @form_type = "form"
    end

    it "should include the fsa object, fieldset object, and a values hash" do
      lambda { fieldset_renderer(@fsa,@fieldset,@values, @form_type) }.should_not raise_error
    end

    it "should call the children method on the fieldset object" do
      @fieldset.should_receive(:children).and_return []
      fieldset_renderer(@fsa,@fieldset,@values, @form_type)
    end
    
    it "should call the field_renderer method if the current child is a field" do
      @field = mock_model(Field)
      @fieldset.stub!(:children).and_return [@field]
      self.should_receive(:field_renderer).and_return []
      fieldset_renderer(@fsa,@fieldset,@values, @form_type)
    end
    
    it "should call the fieldset_renderer recursively if the current child is a fieldset" do
      @child_fieldset = mock_model(Fieldset)
      @fieldset.stub!(:children).and_return [@child_fieldset]
      self.should_receive(:fieldset_renderer)
      fieldset_renderer(@fsa,@fieldset,@values, @form_type)
    end

    it "should include markup for the fieldset itself" do
      fieldset_renderer(@fsa,@fieldset,@values, @form_type).should satisfy {
        |x| !x.select{ |v| v =~ /id='fieldset-326'/ }.nil?
      }
    end
    
    it "should return a array of html elements" do
      fieldset_renderer(@fsa,@fieldset,@values, @form_type).should be_a_kind_of Array
    end
  end

  describe ".field_form_renderer" do
    before(:each) do
      @fsa = mock_model(FieldsetAssociator)
      @field = Field.new
      @field.stub!(:id).and_return 420
      @field.stub!(:html_attributes).and_return []
      @field.stub!(:has_default?).and_return false
      @field.stub!(:default).and_return ""
      @field.stub!(:field_type).and_return ""
      @field.stub!(:options).and_return []
      @values = []
    end
    
    it "should include the form object, the field object, and an array of values" do
      lambda { field_form_renderer(@fsa,@field,@values) }.should_not raise_error
    end

    it "should call the html_attributes method for the field" do
      @field.should_receive(:html_attributes)
      field_form_renderer(@fsa,@field,@values)
    end

    it "should call the field_options method for the field if it is a select" do
      @field.stub!(:field_type).and_return 'select'
      @field.should_receive(:options)
      field_form_renderer(@fsa,@field,@values)
    end
    
    it "should call the field_options method for the field if it is a multiple select" do
      @field.stub!(:field_type).and_return 'multiple_select'
      @field.should_receive(:options)
      field_form_renderer(@fsa,@field,@values)
    end
    
    it "should call the field_options method for the field if it is a checkbox" do
      @field.stub!(:field_type).and_return 'checkbox'
      @field.should_receive(:options)
      field_form_renderer(@fsa,@field,@values)
    end
    
    it "should call the field_options method for the field if it is a radio" do
      @field.stub!(:field_type).and_return 'radio'
      @field.should_receive(:options)
      field_form_renderer(@fsa,@field,@values)
    end
    
    
    ## HELPER TAGS
    
    it "should have a label tag" do
      field_form_renderer(@fsa,@field,@values).should satisfy {
        |x| !x.select{ |v| v =~ /<label for=/ }.nil?
      }
    end
    
    it "should call select_tag if the type is select" do
      @field.stub!(:field_type).and_return 'select'
      should_receive(:select_tag)
      field_form_renderer(@fsa,@field,@values)
    end
    
    it "should call select_tag if the type is multiple select" do
      @field.stub!(:field_type).and_return 'multiple_select'
      should_receive(:select_tag)
      field_form_renderer(@fsa,@field,@values)
    end
    
    it "should call text_field if the type is textfield" do
      @field.stub!(:field_type).and_return 'textfield'
      should_receive(:text_field)
      field_form_renderer(@fsa,@field,@values)
    end

    it "should call check_box if the type is checkbox" do
      option = mock_model(FieldOption)
      option.stub!(:name).and_return ""
      @field.stub!(:field_type).and_return 'checkbox'
      @field.stub!(:options).and_return [option]
      should_receive(:check_box)
      field_form_renderer(@fsa,@field,@values)
    end
    
    it "should call radio_button if the type is radio" do
      option = mock_model(FieldOption)
      option.stub!(:name).and_return ""
      @field.stub!(:field_type).and_return 'radio'
      @field.stub!(:options).and_return [option]
      should_receive(:radio_button)
      field_form_renderer(@fsa,@field,@values)
    end
    
    it "should have a text_area tag if the type is textarea" do
      field_form_renderer(@fsa,@field,@values).should satisfy {
        |x| !x.select{ |v| v =~ /<textarea/ }.nil?
      }
    end

    it "should call date_select if the type is date" do
      @field.stub!(:field_type).and_return 'date'
      should_receive(:date_select)
      field_form_renderer(@fsa,@field,@values)
    end

    it "should call datetime_select if the type is datetime" do
      @field.stub!(:field_type).and_return 'datetime'
      should_receive(:datetime_select)
      field_form_renderer(@fsa,@field,@values)
    end


    it "should return an array of html" do
      field_form_renderer(@fsa,@field,@values).should be_a_kind_of Array
    end
  end

  describe "field_show_renderer method" do
    before(:each) do
      @fsa = mock_model(FieldsetAssociator)
      @field = Field.new
      @field.stub!(:id).and_return 420
      @values = []
    end

    it "should return an array of strings" do
      result = field_show_renderer(@fsa, @field, @values)
      result.should be_a_kind_of Array
      result.each do |r|
        r.should be_a_kind_of String
      end
    end

    it "should include the class dynamic_fieldsets_field" do
      field_show_renderer(@fsa, @field, @values).join().should match /dynamic_fieldsets_field/
    end

    it "should include the class dynamic_fieldsets_field_label" do
      field_show_renderer(@fsa, @field, @values).join().should match /dynamic_fieldsets_field_label/
    end

    it "should include the class dynamic_fieldsets_field_value" do
      field_show_renderer(@fsa, @field, @values).join().should match /dynamic_fieldsets_field_value/
    end

    it "should return 'No answer given' if the field has no answer for the current fieldset associator" do
      field_show_renderer(@fsa, @field, @values).join().should match /No answer given/
    end
  end
  
  describe "field_renderer method" do
    it "should call the form helper if the form_type is form"
    it "should default to the show helper if the form_type is not form"
  end
end
