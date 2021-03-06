require 'spec_helper'
  
describe DynamicFieldsets::FieldDefault do
  include FieldDefaultHelper

  it "should respond to field" do
    field_default = DynamicFieldsets::FieldDefault.new
    field_default.should respond_to :field
  end
  
  describe "validations" do
    before(:each) do
      @field_default = DynamicFieldsets::FieldDefault.new
    end

    it "should be valid" do
      @field_default.attributes = valid_attributes
      @field_default.should be_valid
    end

    it "should require a label" do
      @field_default.should have(1).error_on(:value)
    end
  end  

  # note that these are saving because I am testing a before save
  # instead of testing the method directly
  describe "convert_option_name_to_id method" do
    before(:each) do
      @field = DynamicFieldsets::Field.new(:type => "select")
      @field.stub!(:id).and_return(1)
      @field_option = DynamicFieldsets::FieldOption.new(:name => "test value")
      @field_option.stub!(:id).and_return(2)
      DynamicFieldsets::FieldOption.stub!(:find_by_name).and_return(@field_option)
      @default = DynamicFieldsets::FieldDefault.new(:field => @field, :value => "test value")
    end

    # removing this validation until the sti code is inplace
    # changed the field name from field_type to type so rails is trying to find models
    it "should convert the value to a field option id if the field's type is an option type" do
      pending
      @default.save
      @default.value.should == @field_option.id
    end

    it "should retain it's value if the field's type is not an option type" do
      @field.type = "textfield"
      @default.save
      @default.value.should_not == @field_option.id
    end
  end

  describe "pretty_value method" do
    before(:each) do
      @field = DynamicFieldsets::Field.new(:type => "select")
      @field.stub!(:id).and_return(1)
      @field_option = DynamicFieldsets::FieldOption.new(:name => "test value")
      @field_option.stub!(:id).and_return(2)
      DynamicFieldsets::FieldOption.stub!(:find_by_name).and_return(@field_option)
      @default = DynamicFieldsets::FieldDefault.new(:field => @field, :value => "test value")
    end

    # removing this validation until the sti code is inplace
    # changed the field name from field_type to type so rails is trying to find models
    it "should return the value if the field is not an option type" do
      pending
      @field.type = "textfield"
      @default.pretty_value.should == @default.value
    end

    it "should return the field option name if the field is an option type" do
      @default.pretty_value.should == @field_option.name
    end
      
    it "should return the value if the field is not set" do
      @default.field = nil
      @default.pretty_value.should == @default.value
    end
  end
end
