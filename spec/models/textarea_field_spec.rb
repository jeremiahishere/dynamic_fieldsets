require 'spec_helper'

describe DynamicFieldsets::TextareaField do
  before do
    @textarea = DynamicFieldsets::TextareaField.new
  end
  subject { @textarea }

  describe "mixins" do
    it "should include the single answer mixin" do
      @textarea.class.should respond_to :acts_as_field_with_single_answer
    end
  end

  # instance methods

  describe ".default_cols" do
    it "should return 40" do
      @textarea.default_cols.should == 40
    end
  end

  describe ".default_rows" do
    it "should return 6" do
      @textarea.default_rows.should == 6
    end
  end
  
  describe ".html_attribute_hash" do
    it "should call and include cols" do
      @textarea.should_receive(:default_cols)
      @textarea.html_attribute_hash
    end
    
    it "should call and include rows" do
      @textarea.should_receive(:default_rows)
      @textarea.html_attribute_hash
    end
    
    it "cols and rows should be overridden by the arguments if set" do
      @html_attribute1 = DynamicFieldsets::FieldHtmlAttribute.new(:attribute_name => 'rows', :value => 10)
      @html_attribute2 = DynamicFieldsets::FieldHtmlAttribute.new(:attribute_name => 'cols', :value => 10)
      @textarea.stub!(:field_html_attributes).and_return [@html_attribute1, @html_attribute2]
      @textarea.html_attribute_hash.should == {:cols => 10, :rows => 10}
    end

    it "should call super" do
      #called in superclass .html_attributes_hash
      @textarea.should_receive(:field_html_attributes)
      @textarea.html_attribute_hash
    end
  end

  describe "form_partial_locals" do
    before (:all) do
      @fsa = DynamicFieldsets::FieldsetAssociator.new
      @fsa.stub!(:id).and_return(1)
      @fsc = DynamicFieldsets::FieldsetChild.new
      @fsc.stub!(:id).and_return(1)
      @attributes = {:fsa => @fsa, :fieldset_child => @fsc, :values => [], :value => nil}
    end

    it "should call super" do
      # fsa and fsc are set in the superclass (Field) form_partial_locals method
      @textarea.form_partial_locals(@attributes)[:fsa].should == @fsa
      @textarea.form_partial_locals(@attributes)[:fieldset_child].should == @fsc
    end

    it "should call value_or_default_for_form" do
      @textarea.should_receive(:value_or_default_for_form)
      @textarea.form_partial_locals(@attributes)
    end

    it "should include content and attrs" do
      @textarea.form_partial_locals(@attributes)[:content].should be_true
      @textarea.form_partial_locals(@attributes)[:attrs].should be_true
    end
  end
end
