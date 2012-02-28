require 'spec_helper'

describe DynamicFieldsets::TextareaField do
  before do
    @textarea = DynamicFieldsets::TextareaField.new
  end
  subject { @textarea }

  describe "mixins" do
    it "should include the single answer mixin"
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
    it "should call and include cols"
    it "should call and include rows"
    it "cols and rows should be overridden by the arguments if set"
    it "should call super"
  end

  describe "form_partial_locals" do
    it "should call super"
    it "should call value_or_default_for_form"
    it "should do a few other things"
  end
end
