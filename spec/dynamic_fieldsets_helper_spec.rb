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
      lambda { dynamic_fieldset_renderer(@fsa) }.should_not raise_error
    end

    it "should call the fieldset_renderer with the fsa's root fieldset" do
      @fsa.should_receive(:fieldset)
      dynamic_fieldset_renderer(@fsa)
    end

    it "should return a string of html" do
      dynamic_fieldset_renderer(@fsa).should be_a_kind_of String
    end
  end

  describe ".fieldset_renderer" do
    before(:each) do
      @fsa = mock_model(FieldsetAssociator)
      @fieldset = Fieldset.new
      @fieldset.stub!(:id).and_return 326
      @values = {}
    end

    it "should include the fsa object, fieldset object, and a values hash" do
      lambda { fieldset_renderer(@fsa,@fieldset,@values) }.should_not raise_error
    end

    it "should call the children method on the fieldset object" do
      @fieldset.should_receive(:children).and_return []
      fieldset_renderer(@fsa,@fieldset,@values)
    end
    
    it "should call the field_renderer method if the current child is a field" do
      @field = mock_model(Field)
      @fieldset.stub!(:children).and_return [@field]
      self.should_receive(:field_renderer).and_return []
      fieldset_renderer(@fsa,@fieldset,@values)
    end
    
    it "should call the fieldset_renderer recursively if the current child is a fieldset" do
      @child_fieldset = mock_model(Fieldset)
      @fieldset.stub!(:children).and_return [@child_fieldset]
      self.should_receive(:fieldset_renderer)
      fieldset_renderer(@fsa,@fieldset,@values)
    end

    it "should include markup for the fieldset itself" do
      fieldset_renderer(@fsa,@fieldset,@values).should satisfy {
        |x| !x.select{ |v| v =~ /id='fieldset-326'/ }.nil?
      }
    end
    
    it "should return a array of html elements" do
      fieldset_renderer(@fsa,@fieldset,@values).should be_a_kind_of Array
    end
    
  end

  describe ".field_renderer" do
    before(:each) do
      @fsa = mock_model(FieldsetAssociator)
      @field = Field.new
      @field.stub!(:id).and_return 420
      @field.stub!(:html_attributes).and_return []
      @field.stub!(:has_default?).and_return false
      @field.stub!(:default).and_return ""
      @field.stub!(:type).and_return ""
      @field.stub!(:options).and_return []
      @values = []
    end
    
    it "should include the form object, the field object, and an array of values" do
      lambda { field_renderer(@fsa,@field,@values) }.should_not raise_error
    end

    it "should call the html_attributes method for the field" do
      @field.should_receive(:html_attributes)
      field_renderer(@fsa,@field,@values)
    end
    
    it "should call the default method for the field" do
      pending
      @field.should_receive(:default)
      field_renderer(@fsa,@field,@values)
    end

    it "should call the field_options method for the field if it is a select" do
      @field.stub!(:type).and_return 'select'
      @field.should_receive(:options)
      field_renderer(@fsa,@field,@values)
    end
    
    it "should call the field_options method for the field if it is a multiple select" do
      @field.stub!(:type).and_return 'multiple_select'
      @field.should_receive(:options)
      field_renderer(@fsa,@field,@values)
    end
    
    it "should call the field_options method for the field if it is a checkbox" do
      @field.stub!(:type).and_return 'checkbox'
      @field.should_receive(:options)
      field_renderer(@fsa,@field,@values)
    end
    
    it "should call the field_options method for the field if it is a radio" do
      @field.stub!(:type).and_return 'radio'
      @field.should_receive(:options)
      field_renderer(@fsa,@field,@values)
    end
    
    
    ## HELPER TAGS
    
    it "should have a label tag" do
      field_renderer(@fsa,@field,@values).should satisfy {
        |x| !x.select{ |v| v =~ /<label for=/ }.nil?
      }
    end
    
    it "should call collection_select if the type is select" do
      @field.stub!(:type).and_return 'select'
      should_receive(:collection_select)
      field_renderer(@fsa,@field,@values)
    end
    
    it "should call collection_select if the type is multiple select" do
      @field.stub!(:type).and_return 'multiple_select'
      should_receive(:collection_select)
      field_renderer(@fsa,@field,@values)
    end
    
    it "should call text_field if the type is textfield" do
      @field.stub!(:type).and_return 'textfield'
      should_receive(:text_field)
      field_renderer(@fsa,@field,@values)
    end

    it "should call check_box if the type is checkbox" do
      option = mock_model(FieldOption)
      option.stub!(:label).and_return ""
      @field.stub!(:type).and_return 'checkbox'
      @field.stub!(:options).and_return [option]
      should_receive(:check_box)
      field_renderer(@fsa,@field,@values)
    end
    
    it "should call radio_button if the type is radio" do
      option = mock_model(FieldOption)
      option.stub!(:label).and_return ""
      @field.stub!(:type).and_return 'radio'
      @field.stub!(:options).and_return [option]
      should_receive(:radio_button)
      field_renderer(@fsa,@field,@values)
    end
    
    it "should call text_area if the type is textarea" do
      pending
      @field.stub!(:type).and_return 'textarea'
      should_receive(:text_area)
      field_renderer(@fsa,@field,@values)
    end

    it "should call date_select if the type is date" do
      @field.stub!(:type).and_return 'date'
      should_receive(:date_select)
      field_renderer(@fsa,@field,@values)
    end

    it "should call datetime_select if the type is datetime" do
      @field.stub!(:type).and_return 'datetime'
      should_receive(:datetime_select)
      field_renderer(@fsa,@field,@values)
    end


    it "should return an array of html" do
      field_renderer(@fsa,@field,@values).should be_a_kind_of Array
    end
    
  end
end
