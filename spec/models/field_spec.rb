require 'spec_helper'

describe DynamicFieldsets::Field do
  include FieldHelper

  before do
    @field = DynamicFieldsets::Field.new
  end
  subject { @field }

  describe "fields" do
    it { should respond_to :name }
    it { should respond_to :label }
    it { should respond_to :type }
    it { should respond_to :required }
    it { should respond_to :enabled }
  end

  describe "associations" do
    before do
      pending "shoulda installation"
    end

    it { should have_many :fieldset_children }
    it { should have_many :parent_fieldsets }
    it { should have_many :field_options }
    it { should have_many :field_defaults }
    it { should have_many :field_html_attributes }
  end

  describe "validations" do
    before(:each) do
      @field = DynamicFieldsets::Field.new
    end

    it "should not be valid because it should be instantiated through the child classes" do
      @field.attributes = valid_attributes
      @field.should_not be_valid
    end

    it "should require name" do
      @field.should have(1).error_on(:name)
    end
    
    it "should require label" do
      @field.should have(1).error_on(:label)
    end

    it "should require type" do
      @field.should have(1).error_on(:type)
    end

    it "should require enabled true or false" do
      @field.enabled = true
      @field.should have(0).error_on(:enabled)
    end

    it "should require required true or false" do
      @field.required = false
      @field.should have(0).error_on(:required)
    end

    # this validation now comes from the field option mixin
    # whenever we get around to tests, this needs to be moved over.
    # lets see how long this takes (JH 2-27-2012)
    it "should require options if the type is one that requires options" do
      pending "this needs to be moved to the field option mixin"
      @field.type = "select"
      @field.should have(1).error_on(:field_options)
    end
  end

  # Scopes and Static Methods

  it { DynamicFieldsets::Field.should respond_to :descendants }
  describe ".descendants" do
    it "should call super if cache classes is on"
    it "should call the config if cache classes is off"
  end

  it { DynamicFieldsets::Field.should respond_to :descendant_collection }
  describe ".descendant_collection" do
    it "should call descendants"
    it "should convert the class names to humanized strings"
  end

  describe "form partial methods" do
    it { should respond_to :form_partial }
    describe ".form_partial" do
      it "needs tests"
    end

    it { should respond_to :form_header_partial }
    describe ".form_header_partial" do
      it "needs tests"
    end

    it { should respond_to :use_form_header_partial? }
    describe ".use_form_header_partial?" do
      it "needs tests"
    end

    it { should respond_to :form_footer_partial }
    describe ".form_footer_partial" do
      it "needs tests"
    end

    it { should respond_to :use_form_footer_partial? }
    describe ".use_form_footer_partial?" do
      it "needs tests"
    end

    it { should respond_to :form_partial_locals }
    describe ".form_partial_locals" do
      it "needs tests"
    end

    it { should respond_to :html_attribute_hash }
    describe ".html_attribute_hash" do
      it "needs tests"
    end
  end

  describe "show partial methods" do

    it { should respond_to :show_partial }
    describe ".show_partial" do
      it "needs tests"
    end

    it { should respond_to :show_header_partial }
    describe ".show_header_partial" do
      it "needs tests"
    end

    it { should respond_to :use_show_header_partial? }
    describe ".use_show_header_partial?" do
      it "needs tests"
    end

    it { should respond_to :show_footer_partial }
    describe ".show_footer_partial" do
      it "needs tests"
    end

    it { should respond_to :use_show_footer_partial? }
    describe ".use_show_footer_partial?" do
      it "needs tests"
    end

    it { should respond_to :show_partial_locals }
    describe ".show_partial_locals" do
      it "needs tests"
    end

    it { should respond_to :get_value_for_show }
    describe ".get_value_for_show" do
      it "needs tests"
    end
  end

  # other methods

  it { should respond_to :has_defaults? }
  describe "has_defaults?" do
    before(:each) do
      @field = DynamicFieldsets::Field.new
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

  it { should respond_to :in_use? }
  describe "in_use? method" do
    before(:each) do
      @field = DynamicFieldsets::Field.new
      @field.stub!(:id).and_return(1)

    end
    it "should return true if there is a field record associated with the field" do
      @fieldset_child = DynamicFieldsets::FieldsetChild.new(:child => @field, :fieldset => nil )
      @fieldset_child.stub!(:field_records).and_return(["random", "array" "of", "stuff"])
      @field.stub!(:fieldset_children).and_return([@fieldset_child])

      @field.in_use?.should be_true
    end

    it "should return true if the field is in a fieldset (through a fieldset child)" do
      @fieldset = DynamicFieldsets::Fieldset.new
      @fieldset.stub!(:id).and_return(2)
      @fieldset_child = DynamicFieldsets::FieldsetChild.new(:child => @field, :fieldset_id => @fieldset.id)
      @field.stub!(:fieldset_children).and_return([@fieldset_child])

      @field.in_use?.should be_true
    end

    it "should return false otherwise" do
      @field.in_use?.should be_false
    end
  end

  it { should respond_to :uses_field_options? }
  describe ".uses_field_options?" do
    it "should return false" do
      @field.uses_field_options?.should be_false
    end
  end

  it { should respond_to :collect_default_values }
  describe ".collect_default_values" do
    it "needs tests"
  end

  it { should respond_to :get_values_using_fsa_and_fsc }
  describe ".get_values_using_fsa_and_fsc" do
    it "needs tests"
  end

  it { should respond_to :collect_field_records_by_fsa_and_fsc }
  describe ".collect_field_records_by_fsa_and_fsc" do
    it "needs tests"
  end

  it { should respond_to :update_field_records }
  describe ".update_field_records" do
    it "should throw an error" do
      lambda { @field.update_field_records }.should raise_exception
    end
  end

  describe "options" do
    before do
      pending "This code has been moved to the field option mixin"
    end

    it "should return options from the field options table if enabled" do
      field = DynamicFieldsets::Field.new
      field_option = mock_model(DynamicFieldsets::FieldOption)
      field_option.stub!(:enabled).and_return(true)
      field.should_receive(:field_options).and_return([field_option])
      field.options.should include field_option
    end
    it "should not return disabled options from the field options table" do
      field = DynamicFieldsets::Field.new
      field_option = mock_model(DynamicFieldsets::FieldOption)
      field_option.stub!(:enabled).and_return(false)
      field.should_receive(:field_options).and_return([field_option])
      field.options.should_not include field_option
    end
  end

  describe "default" do
    before(:each) do
      pending "this code has been moved to the single answer mixin"
      @field = DynamicFieldsets::Field.new
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
      pending "this code has been moved to the multiple answer mixin"
      @field = DynamicFieldsets::Field.new
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
end
