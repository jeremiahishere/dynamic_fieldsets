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
      parent_fieldset = DynamicFieldsets::Fieldset.create(:name => "test", :nkey => "parent_fieldset", :description => "test")
      child_fieldset = DynamicFieldsets::Fieldset.create(:name => "test", :nkey => "child_fieldset", :description => "test")
      @fsa = DynamicFieldsets::FieldsetAssociator.create(:fieldset_id => parent_fieldset.id, :fieldset_model_id => 1, :fieldset_model_type => "Test", :fieldset_model_name => "test")
      fsc = DynamicFieldsets::FieldsetChild.create(:fieldset_id => parent_fieldset.id, :child_id => child_fieldset.id, :child_type => "DynamicFieldsets::Fieldset")
      @attributes = {:fsa => @fsa, :fieldset_child => fsc, :values => [], :value => []}
    end
    it "should call super" do
      #fsa, fieldset_child, attrs, object, and method get set in superclass Field form_partial_locals method
      @checkbox.form_partial_locals(@attributes)[:fsa].should == @fsa
    end
    it "should do a bunch of stuff with the options key" do
      @checkbox.form_partial_locals(@attributes)[:options][0][:name] == "one"
      @checkbox.form_partial_locals(@attributes)[:options][0][:name] == "two"
    end
  end
end
