require 'spec_helper'

describe DynamicFieldsets::RadioField do
  it "needs tests"
  before do
    @radio = DynamicFieldsets::RadioField.new
  end
  subject { @radio }

  describe "mixins" do
    it "should include the field options mixin"
    it "should include the single answer mixin"
  end

  # instance methods
  #
  describe ".form_partial_locals" do
    it "should call super"
    it "needs tests"
  end
end
