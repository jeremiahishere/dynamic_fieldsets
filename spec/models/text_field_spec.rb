require 'spec_helper'

describe DynamicFieldsets::TextField do
  before do
    @text = DynamicFieldsets::TextField.new
  end
  subject { @text }

  describe "mixins" do
    it "should include the single answer mixin"
  end

  # instance methods

  describe "form_partial_locals" do
    it "should call super"
    it "should call value_or_default_for_form"
  end
end
