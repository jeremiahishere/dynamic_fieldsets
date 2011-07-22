require 'spec_helper'
include DynamicFieldsets

describe DynamicFieldsetsHelper do
  include DynamicFieldsetsHelper
  include FieldsetHelper
  describe ".dynamic_fieldset_renderer" do
    before(:each) do
      @fsa = mock_model(FieldsetAssociator)
      @form = "" # ...
    end

    it "should respond to dynamic_fieldset_renderer" do
      self.should respond_to :dynamic_fieldset_renderer
    end

    it "should include a form object and a field set associator object" do
      dynamic_fieldset_renderer(@fsa,@form).should_not raise_error(Error)
    end

    it "should call the fieldset_renderer with the fsa's root fieldset" do
      @fsa.should_receive(:fieldset)
      dynamic_fieldset_renderer(@fsa,@form)
    end

    it "should return a string of html" do
      dynamic_fieldset_renderer.should be_a_kind_of String
    end
  end

  describe ".fieldset_renderer" do
    before(:each) do
      @fieldset = Fieldset.new
      @fieldset.stub!(:id).and_return 326
      @form = ""
      @values = {}
    end
    
    it "should respond to fieldset_renderer" do
      pending("How do I test helpers?")
      self.should respond_to :fieldset_renderer
    end

    it "should include the form object, fieldset object, and a values hash" do
      lambda { fieldset_renderer(@fieldset,@form,@values) }.should_not raise_error
    end

    it "should call the children method on the fieldset object" do
      @fieldset.should_receive(:children).and_return []
      fieldset_renderer(@fieldset,@form,@values)
    end
    
    it "should call the field_renderer method if the current child is a field" do
      @field = mock_model(Field)
      @fieldset.stub!(:children).and_return [@field]
      self.should_receive(:field_renderer).and_return []
      fieldset_renderer(@fieldset,@form,@values)
    end
    
    it "should call the fieldset_renderer recursively if the current child is a fieldset" do
      @child_fieldset = mock_model(Fieldset)
      @fieldset.stub!(:children).and_return [@child_fieldset]
      self.should_receive(:fieldset_renderer)
      fieldset_renderer(@fieldset,@form,@values)
    end

    it "should include markup for the fieldset itself" do
      fieldset_renderer(@fieldset,@form,@values).should include "id='fieldset-#{@fieldset.id}'"
    end
    
    it "should return a array of html elements" do
      fieldset_renderer(@fieldset,@form,@values).should be_a_kind_of Array
    end
    
  end

  describe ".field_renderer" do
    before(:each) do
      @form = ""
      @field = mock_model(Field)
      @values = []
    end
    
    it "should respond to field_renderer" do
      pending("How do I test helpers?")
      self.should respond_to :field_renderer
    end
    
    it "should include the form object, the field object, and an array of values" do
      lambda { field_renderer(@field,@form,@values) }.should_not raise_error
    end

    it "should call the html_attributes method for the field" do
      @field.should_receive(:html_attributes)
      field_renderer(@field,@form,@values)
    end
    
    it "should call the field_defaults method for the field" do
      @field.should_receive(:field_defaults)
      field_renderer(@field,@form,@values)
    end

    it "should call the field_options method for the field if it is a select" do
      @field.stub!(:type).and_return 'select'
      @field.should_receive(:field_options)
      field_renderer(@field,@form,@values)
    end
    
    it "should call the field_options method for the field if it is a multiple select" do
      @field.stub!(:type).and_return 'multiple_select'
      @field.should_receive(:field_options)
      field_renderer(@field,@form,@values)
    end
    
    it "should call the field_options method for the field if it is a checkbox" do
      @field.stub!(:type).and_return 'checkbox'
      @field.should_receive(:field_options)
      field_renderer(@field,@form,@values)
    end
    
    it "should call the field_options method for the field if it is a radio" do
      @field.stub!(:type).and_return 'radio'
      @field.should_receive(:field_options)
      field_renderer(@field,@form,@values)
    end
    
    
    ## HELPER TAGS
    
    it "should call label_tag" do
      @field.should_receive(:label_tag)
      field_renderer(@field,@form,@values)
    end
    
    it "should call select_tag if the type is select" do
      @field.stub!(:type).and_return 'select'
      @field.should_receive(:select_tag)
      @field.should_receive(:options_for_select)
      field_renderer(@field,@form,@values)
    end
    
    it "should call select_tag if the type is multiple select" do
      @field.stub!(:type).and_return 'multiple_select'
      @field.should_receive(:select_tag)
      @field.should_receive(:options_for_select)
      field_renderer(@field,@form,@values)
    end
    
    it "should call text_field_tag if the type is textfield" do
      @field.stub!(:type).and_return 'textfield'
      @field.should_receive(:text_field_tag)
      field_renderer(@field,@form,@values)
    end

    it "should call check_box_tag if the type is checkbox" do
      @field.stub!(:type).and_return 'checkbox'
      @field.should_receive(:check_box_tag)
      field_renderer(@field,@form,@values)
    end
    
    it "should call radio_button_tag if the type is radio" do
      @field.stub!(:type).and_return 'radio'
      @field.should_receive(:radio_button_tag)
      field_renderer(@field,@form,@values)
    end
    
    it "should call text_area_tag if the type is textarea" do
      @field.stub!(:type).and_return 'textarea'
      @field.should_receive(:text_area_tag)
      field_renderer(@field,@form,@values)
    end

    it "should call select_date if the type is date" do
      @field.stub!(:type).and_return 'date'
      @field.should_receive(:select_date)
      field_renderer(@field,@form,@values)
    end

    it "should call select_datetime if the type is datetime" do
      @field.stub!(:type).and_return 'datetime'
      @field.should_receive(:select_datetime)
      field_renderer(@field,@form,@values)
    end


    it "should return a string of html" do
      field_renderer(@field,@form,@values).should be_a_kind_of Array
    end
    
  end
end