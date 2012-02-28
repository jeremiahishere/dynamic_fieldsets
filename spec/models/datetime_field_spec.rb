require 'spec_helper'

describe DynamicFieldsets::DatetimeField do
  before do
    @datetime = DynamicFieldsets::DatetimeField.new
  end
  subject { @datetime }

  describe "mixins" do
    it "should include the single answer mixin"
  end

  # instance methods
  it { should respond_to :get_datetime_or_today }
  describe ".get_datetime_or_today" do
    it "should return the inputted datetime"
    it "should return today if the inputted datetime is empty"
  end

  describe ".form_partial_locals" do
    it "should call super"
    it "should include start year and default in the output"
  end
end
