require 'spec_helper'

describe DynamicFieldsets::MultipleSelectField do
  it "needs tests"
  before do
    @mselect = DynamicFieldsets::MultipleSelectField.new
  end
  subject { @mselect }

  describe "mixins" do
    it "should include the field options mixin"
    it "should include the multiple answers mixin"
  end

  # instance methods

  describe ".html_attributes_hash" do
    it "should call super"
    it "should include multiple: true"
  end

  describe ".form_partial_locals" do
    it "should call super"
    it "should call values_or_defaults_for_form"
    it "should include selected_ids and collection"
  end

  describe ".collect_default_values" do
    it "needs tests"  
  end
end
