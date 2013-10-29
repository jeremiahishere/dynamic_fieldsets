require 'spec_helper'

describe DynamicFieldsets::MultipleSelectField do
  it "needs tests"
  before do
    @mselect = DynamicFieldsets::MultipleSelectField.create(:name => "test", :label => "test")
  end
  subject { @mselect }

  describe "mixins" do
    it "should include the field options mixin" do
      @mselect.class.should respond_to :acts_as_field_with_field_options
    end
    it "should include the multiple answers mixin" do
      @mselect.class.should respond_to :acts_as_field_with_multiple_answers
    end
  end

  # instance methods

  describe ".html_attributes_hash" do
    it "should call super" do
      #called in superclass .html_attributes_hash
      @mselect.should_receive(:field_html_attributes)
      @mselect.html_attribute_hash
    end
    it "should include multiple: true" do
      @mselect.html_attribute_hash[:multiple].should be_true
    end
  end

  describe ".form_partial_locals" do
    before (:all) do
      @fsa = DynamicFieldsets::FieldsetAssociator.new
      @fsa.stub!(:id).and_return(1)
      @fsc = DynamicFieldsets::FieldsetChild.new
      @fsc.stub!(:id).and_return(1)
      @attributes = {:fsa => @fsa, :fieldset_child => @fsc, :values => [], :value => nil}
    end

    it "should call super" do
      # fsa and fsc are set in the superclass (Field) form_partial_locals method
      @mselect.form_partial_locals(@attributes)[:fsa].should == @fsa
      @mselect.form_partial_locals(@attributes)[:fieldset_child].should == @fsc
    end

    it "should call values_or_defaults_for_form"
    it "should include selected_ids and collection"
  end

  describe ".collect_default_values" do
    it "needs tests"  
  end
end
