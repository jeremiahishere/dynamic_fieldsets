require 'spec_helper'

describe DynamicFieldsets::CheckboxField do
  before (:all) do
    op1 = DynamicFieldsets::FieldOption.new(:name => "one")
    op2 = DynamicFieldsets::FieldOption.new(:name => "two")
    @checkbox = DynamicFieldsets::CheckboxField.create(:name => "test", :label => "test", :field_options => [op1,op2])
  end
  subject { @checkbox }

  describe "mixins" do
    it "should include the field options mixin" do
      @checkbox.class.should respond_to :acts_as_field_with_field_options
    end
    it "should include the multiple answers mixin" do
      @checkbox.class.should respond_to :acts_as_field_with_multiple_answers
    end
  end

  # instance methods
  describe ".form_partial_locals" do
    before (:all) do
      @fsa = DynamicFieldsets::FieldsetAssociator.new
      @fsa.stub!(:id).and_return(1)
      @fsc = DynamicFieldsets::FieldsetChild.new
      @fsc.stub!(:id).and_return(1)
      @attributes = {:fsa => @fsa, :fieldset_child => @fsc, :values => [], :value => []}
    end
    it "should call super" do
      # fsa and fsc are set in the superclass (Field) form_partial_locals method
      @checkbox.form_partial_locals(@attributes)[:fsa].should == @fsa
      @checkbox.form_partial_locals(@attributes)[:fieldset_child].should == @fsc
    end
    it "should do a bunch of stuff with the options key" do
      @checkbox.form_partial_locals(@attributes)[:options][0][:name] == "one"
      @checkbox.form_partial_locals(@attributes)[:options][0][:name] == "two"
    end
  end
end
