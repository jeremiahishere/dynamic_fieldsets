require 'spec_helper'

describe DynamicFieldsets::CheckboxField do
  before do
    @checkbox = DynamicFieldsets::CheckboxField.new
  end
  subject { @checkbox }

  describe "mixins" do
    it "should include the field options mixin"
    it "should include the multiple answers mixin"
  end

  # instance methods
  describe ".form_partial_locals" do
    it "should call super"
    it "should do a bunch of stuff with the options key"
  end
end
