require 'spec_helper'
include DynamicFieldsets
include ActionView::Helpers

describe DynamicFieldsetsHelper do
  include DynamicFieldsetsHelper
  include FieldsetHelper

  before(:each) do
    pending "total rewrite"
  end

  describe "field_renderer method" do
    before(:each) do
      @fsa = mock_model FieldsetAssociator
      @fieldset_child = mock_model FieldsetChild
      @values = []
    end
    
    it "should call the form helper if the form_type is form" do
      self.should_receive(:field_form_renderer)
      field_renderer(@fsa, @fieldset_child, @values, "form")
    end

    it "should default to the show helper if the form_type is not form" do
      self.should_receive(:field_show_renderer)
      field_renderer(@fsa, @fieldset_child, @values, "show")
    end
  end

  describe "field_show_renderer method" do
    before(:each) do
      pending "This was significantly refactored"
      @fsa = mock_model FieldsetAssociator
      @field = Field.new
      @fieldset_child = mock_model FieldsetChild
      @fieldset_child.stub!(:child).and_return @field
      @fieldset_child.stub!(:id).and_return 420
      @values = []
    end

    it "should return an array of strings" do
      result = field_show_renderer(@fsa, @fieldset_child, @values)
      result.should be_a_kind_of Array
    end

    it "should include the class field" do
      field_show_renderer(@fsa, @fieldset_child, @values).join.should match(/field/)
    end

    it "should include the class label" do
      field_show_renderer(@fsa, @fieldset_child, @values).join.should match(/label/)
    end

    it "should include the class value" do
      field_show_renderer(@fsa, @fieldset_child, @values).join.should match(/value/)
    end

    it "should return 'No answer given' if the field has no answer for the current fieldset associator" do
      field_show_renderer(@fsa, @fieldset_child, nil).join.should match(/No answer given/)
    end
  end

  describe "field_form_renderer" do
    before do
      pending "significant refactoring done here.  probably all of these are trash now"
    end

    describe ".field_form_renderer appends html attributes to the field element" do
      before(:each) do
        @fsa = mock_model FieldsetAssociator
        @field = Field.new
        @fieldset_child = mock_model FieldsetChild
        @fieldset_child.stub!(:child).and_return @field
        @fieldset_child.stub!(:id).and_return 200
        
        @field.stub!(:id).and_return 420
        @field.stub!(:has_default?).and_return false
        @field.stub!(:default).and_return ""
        @field.stub!(:options).and_return []
        @values = []
        @htmlattr = mock_model FieldHtmlAttribute
        @htmlattr.stub!(:attribute_name).and_return 'class'
        @htmlattr.stub!(:value).and_return 'test'
        @field.stub!(:field_html_attributes).and_return [@htmlattr]
        @option = mock_model FieldOption
        @option.stub!(:name).and_return 'option1'
      end
      
      it "successfully for fieldtype radio" do
        @field.stub!(:type).and_return 'radio'
        @field.stub!(:options).and_return [@option]
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/class=["']test["']/)
      end
      it "successfully for fieldtype checkbox" do
        @field.stub!(:type).and_return 'checkbox'
        @field.stub!(:options).and_return [@option]
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/class=["']test["']/)
      end
      it "successfully for fieldtype select" do
        @field.stub!(:type).and_return 'select'
        @field.stub!(:options).and_return [@option]
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/class=["']test["']/)
      end
      it "successfully for fieldtype multiple_select" do
        @field.stub!(:type).and_return 'multiple_select'
        @field.stub!(:options).and_return [@option]
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/class=["']test["']/)
      end
      it "successfully for fieldtype textfield" do
        @field.stub!(:type).and_return 'textfield'
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/class=["']test["']/)
      end
      it "successfully for fieldtype textarea" do
        @field.stub!(:type).and_return 'textarea'
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/class=["']test["']/)
      end
      it "successfully for fieldtype date" do
        @field.stub!(:type).and_return 'date'
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/class=["']test["']/)
      end
      it "successfully for fieldtype datetime" do
        @field.stub!(:type).and_return 'datetime'
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/class=["']test["']/)
      end
    end
    
    describe ".field_form_renderer appends the field id and child id attribute to the field element" do
      before(:each) do
        @field_id = 420
        @child_id = 365
        @fsa = mock_model FieldsetAssociator
        @field = Field.new
        @fieldset_child = mock_model FieldsetChild
        @fieldset_child.stub!(:child).and_return @field
        @fieldset_child.stub!(:id).and_return @child_id
        @field.stub!(:id).and_return @field_id
        @field.stub!(:has_default?).and_return false
        @field.stub!(:default).and_return ""
        @field.stub!(:options).and_return []
        @values = []
        @htmlattr = mock_model FieldHtmlAttribute
        @htmlattr.stub!(:attribute_name).and_return 'class'
        @htmlattr.stub!(:value).and_return 'test'
        @field.stub!(:field_html_attributes).and_return [@htmlattr]
        @option = mock_model FieldOption
        @option.stub!(:name).and_return 'option1'
      end
      
      it "successfully for fieldtype radio" do
        @field.stub!(:type).and_return 'radio'
        @field.stub!(:options).and_return [@option]
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/id=["']field-#{@field_id}-child-#{@child_id}["']/)
      end
      it "successfully for fieldtype checkbox" do
        @field.stub!(:type).and_return 'checkbox'
        @field.stub!(:options).and_return [@option]
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/id=["']field-#{@field_id}-child-#{@child_id}["']/)
      end
      it "successfully for fieldtype select" do
        @field.stub!(:type).and_return 'select'
        @field.stub!(:options).and_return [@option]
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/id=["']field-#{@field_id}-child-#{@child_id}["']/)
      end
      it "successfully for fieldtype multiple_select" do
        @field.stub!(:type).and_return 'multiple_select'
        @field.stub!(:options).and_return [@option]
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/id=["']field-#{@field_id}-child-#{@child_id}["']/)
      end
      it "successfully for fieldtype textfield" do
        @field.stub!(:type).and_return 'textfield'
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/id=["']field-#{@field_id}-child-#{@child_id}["']/)
      end
      it "successfully for fieldtype textarea" do
        @field.stub!(:type).and_return 'textarea'
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/id=["']field-#{@field_id}-child-#{@child_id}["']/)
      end
      it "successfully for fieldtype date" do
        @field.stub!(:type).and_return 'date'
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/id=["']field-#{@field_id}-child-#{@child_id}["']/)
      end
      it "successfully for fieldtype datetime" do
        @field.stub!(:type).and_return 'datetime'
        field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/id=["']field-#{@field_id}-child-#{@child_id}["']/)
      end
    end

    describe ".field_form_renderer" do
      before(:each) do
        @fsa = mock_model FieldsetAssociator
        @field = Field.new
        @fieldset_child = mock_model FieldsetChild
        @fieldset_child.stub!(:child).and_return @field
        @fieldset_child.stub!(:id).and_return 300
        @field.stub!(:id).and_return 420
        @field.stub!(:html_attributes).and_return []
        @field.stub!(:has_default?).and_return false
        @field.stub!(:default).and_return ""
        @field.stub!(:type).and_return ""
        @field.stub!(:options).and_return []
        @values = []
      end
      
      it "includes the form object, the field object, and an array of values" do
        lambda { field_form_renderer(@fsa,@fieldset_child,@values) }.should_not raise_error
      end

      it "calls the html_attributes method for the field" do
        @field.should_receive(:field_html_attributes).and_return []
        field_form_renderer(@fsa,@fieldset_child,@values)
      end

      it "calls the field_options method for the field if it is a select" do
        @field.stub!(:type).and_return 'select'
        @field.should_receive(:options)
        field_form_renderer(@fsa,@fieldset_child,@values)
      end
      
      it "calls the field_options method for the field if it is a multiple select" do
        @field.stub!(:type).and_return 'multiple_select'
        @field.should_receive(:options)
        field_form_renderer(@fsa,@fieldset_child,@values)
      end
      
      it "calls the field_options method for the field if it is a checkbox" do
        @field.stub!(:type).and_return 'checkbox'
        @field.should_receive(:options)
        field_form_renderer(@fsa,@fieldset_child,@values)
      end
      
      it "calls the field_options method for the field if it is a radio" do
        @field.stub!(:type).and_return 'radio'
        @field.should_receive(:options)
        field_form_renderer(@fsa,@fieldset_child,@values)
      end
    end 
    
    ## HELPER TAGS
    
    it "has a label tag" do
      field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/<label for=/)
    end
    
    it "does not have a label tag for type instruction" do
      @field.stub!(:type).and_return 'instruction'
      field_form_renderer(@fsa,@fieldset_child,@values).join.should_not match(/<label for=/)
    end
    
    it "displays label content enclosed in <p> tags for type instruction" do
      @field.stub!(:type).and_return 'instruction'
      @field.stub!(:label).and_return 'some label'
      field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/<p>some label<\/p>/)
    end
    
    it "calls select_tag if the type is select" do
      @field.stub!(:type).and_return 'select'
      should_receive(:select_tag)
      field_form_renderer(@fsa,@fieldset_child,@values)
    end
    
    it "calls select_tag if the type is multiple select" do
      @field.stub!(:type).and_return 'multiple_select'
      should_receive(:select_tag)
      field_form_renderer(@fsa,@fieldset_child,@values)
    end
    
    it "has the multiple attribute set if the type is multiple select" do
      @field.stub!(:type).and_return 'multiple_select'
      field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/multiple=["']multiple["']/)
    end
    
    it "calls text_field if the type is textfield" do
      @field.stub!(:type).and_return 'textfield'
      should_receive(:text_field)
      field_form_renderer(@fsa,@fieldset_child,@values)
    end

    it "calls check_box_tag if the type is checkbox" do
      option = mock_model(FieldOption)
      option.stub!(:name).and_return ""
      @field.stub!(:type).and_return 'checkbox'
      @field.stub!(:options).and_return [option]
      should_receive(:check_box_tag)
      field_form_renderer(@fsa,@fieldset_child,@values)
    end
    
    it "calls radio_button if the type is radio" do
      option = mock_model(FieldOption)
      option.stub!(:name).and_return ""
      @field.stub!(:type).and_return 'radio'
      @field.stub!(:options).and_return [option]
      should_receive(:radio_button)
      field_form_renderer(@fsa,@fieldset_child,@values)
    end
    
    it "has a text_area tag if the type is textarea" do
      @field.stub!(:type).and_return 'textarea'
      field_form_renderer(@fsa,@fieldset_child,@values).join.should match(/<textarea/)
    end

    it "calls date_select if the type is date" do
      @field.stub!(:type).and_return 'date'
      should_receive(:date_select)
      field_form_renderer(@fsa,@fieldset_child,@values)
    end

    it "calls datetime_select if the type is datetime" do
      @field.stub!(:type).and_return 'datetime'
      should_receive(:datetime_select)
      field_form_renderer(@fsa,@fieldset_child,@values)
    end


    it "returns an array of html" do
      field_form_renderer(@fsa,@fieldset_child,@values).should be_a_kind_of Array
    end
  end

  describe ".fieldset_renderer" do
    before(:each) do
      @fsa = mock_model(FieldsetAssociator)
      @fieldset = Fieldset.new
      @fieldset.stub!(:id).and_return 326
      @values = {}
      @form_type = "form"
      DynamicFieldsets::FieldsetChild.stub!(:where).and_return( [mock_model(FieldsetChild)] )
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
      fieldset_renderer(@fsa,@fieldset,@values, @form_type).join.should match(/id=["']fieldset-326["']/)
    end
    
    it "should return an array of html elements" do
      fieldset_renderer(@fsa,@fieldset,@values, @form_type).should be_a_kind_of Array
    end
  end

  describe "dynamic_fieldset_show_renderer" do
    it "should call dynamic_fieldset_renderer with 'show'" do
      fsa = mock_model(FieldsetAssociator)
      self.should_receive(:dynamic_fieldset_renderer).with(fsa, "show")
      dynamic_fieldset_show_renderer(fsa)
    end
  end

  describe "dynamic_fieldset_form_renderer method" do
    it "should call dynamic_fieldset_renderer with 'form'" do
      pending 'hex is working on this'
      fsa = mock_model(FieldsetAssociator)
      self.should_receive(:dynamic_fieldset_renderer).with(fsa, "form")
      dynamic_fieldset_form_renderer(fsa)
    end
  end

  describe ".dynamic_fieldset_renderer" do
    before(:each) do
      @fsa = mock_model(FieldsetAssociator)
      @fsa.stub!(:id).and_return(2)
      @fsa.stub!(:fieldset).and_return mock_model(Fieldset)
      @fsa.stub!(:fieldset_id).and_return(1)
      @fsa.stub!(:fieldset_model_name).and_return("Turkey")
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

  describe ".javascript_renderer" do
    it "needs tests"
  end
end
