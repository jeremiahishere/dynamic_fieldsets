require 'spec_helper'
include DynamicFieldsets

describe Field do
  include FieldHelper

  it "should respond to parent_fieldset" do
    Field.new.should respond_to :parent_fieldsets
  end

  it "should respond to field_options" do
    Field.new.should respond_to :field_options
  end

  it "should respond to field_defaults" do
    Field.new.should respond_to :field_defaults
  end

  it "should respond to field_html_attributes" do
    Field.new.should respond_to :field_html_attributes
  end

  describe "validations" do
    before(:each) do
      @field = Field.new
    end

    it "should be valid" do
      @field.attributes = valid_attributes
      @field.should be_valid
    end

    it "should require name" do
      @field.should have(1).error_on(:name)
    end
    
    it "should require label" do
      @field.should have(1).error_on(:label)
    end

    # removing this validation until the sti code is inplace
    # changed the field name from field_type to type so rails is trying to find models
    it "should require type" do
      pending
      @field.should have(2).error_on(:type)
    end

    # removing this validation until the sti code is inplace
    # changed the field name from field_type to type so rails is trying to find models
    it "should require type within the allowable types" do
      pending
      @field.type = "unsupported_type"
      @field.should have(1).error_on(:type)
    end

    it "should require type within the allowable types" do
      @field.type = "select"
      @field.should have(0).error_on(:type)
    end


    it "should require enabled true or false" do
      @field.enabled = true
      @field.should have(0).error_on(:enabled)
    end

    it "should require required true or false" do
      @field.required = false
      @field.should have(0).error_on(:required)
    end

    it "should require options if the type is one that requires options" do
      @field.type = "select"
      @field.should have(1).error_on(:field_options)
    end
  end

  describe "options?" do
    before(:each) do
      @field = Field.new
    end

    it "should return true if the field type requires options" do
      @field.type = "select"
      @field.options?.should be_true
    end

    it "should return false if the field does not have options" do
      @field.type = "textfield"
      @field.options?.should be_false
    end
  end

  describe "options" do
    it "should return options from the field options table if enabled" do
      field = Field.new
      field_option = mock_model(DynamicFieldsets::FieldOption)
      field_option.stub!(:enabled).and_return(true)
      field.should_receive(:field_options).and_return([field_option])
      field.options.should include field_option
    end
    it "should not return disabled options from the field options table" do
      field = Field.new
      field_option = mock_model(DynamicFieldsets::FieldOption)
      field_option.stub!(:enabled).and_return(false)
      field.should_receive(:field_options).and_return([field_option])
      field.options.should_not include field_option
    end
  end

  describe "has_defaults?" do
    before(:each) do
      @field = Field.new
    end

    it "should return true if the field default has a value" do
      @field.should_receive(:field_defaults).and_return(["default value"])
      @field.has_defaults?.should be_true
    end
    it "should return false if the field default has no values" do
      @field.should_receive(:field_defaults).and_return([])
      @field.has_defaults?.should be_false
    end
  end

  describe "default" do
    before(:each) do
      @field = Field.new
    end

    it "should return a string if the type does not support multiple options" do
      @field.stub!(:options?).and_return(false)
      @field.should_receive(:field_defaults).and_return(["default value"])
      @field.default.should == "default value"
    end

    it "should return nil if the type supports multiple options" do
      @field.stub!(:options?).and_return(true)
      @field.default.should be_nil
    end
  end 

  describe "defaults" do
    before(:each) do
      @field = Field.new
    end

    it "should return an array if the type supports multiple options" do
      @field.stub!(:options?).and_return(true)
      @field.should_receive(:field_defaults).and_return(["default value"])
      @field.defaults.should == ["default value"]
    end

    it "should return nil if the type does not support multiple options" do
      @field.stub!(:options?).and_return(false)
      @field.defaults.should be_nil
    end
  end

  describe "types method" do
    it "should return an array" do
      Field.field_types.should be_a_kind_of Array
    end
  end

  describe "option_types method" do
    it "should return an array" do
      Field.option_types.should be_a_kind_of Array
    end
  end

  describe "in_use? method" do
    before(:each) do
      @field = Field.new
      @field.stub!(:id).and_return(1)

    end
    it "should return true if there is a field record associated with the field" do
      @fieldset_child = FieldsetChild.new(:child => @field, :fieldset => nil )
      @fieldset_child.stub!(:field_records).and_return(["random", "array" "of", "stuff"])
      @field.stub!(:fieldset_children).and_return([@fieldset_child])

      @field.in_use?.should be_true
    end

    it "should return true if the field is in a fieldset (through a fieldset child)" do
      @fieldset = Fieldset.new
      @fieldset.stub!(:id).and_return(2)
      @fieldset_child = FieldsetChild.new(:child => @field, :fieldset_id => @fieldset.id)
      @field.stub!(:fieldset_children).and_return([@fieldset_child])

      @field.in_use?.should be_true
    end

    it "should return false otherwise" do
      @field.in_use?.should be_false
    end
  end
end
