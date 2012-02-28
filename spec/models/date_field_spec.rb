require 'spec_helper'

describe DynamicFieldsets::DateField do
  before do
    @date = DynamicFieldsets::DateField.new
  end
  subject { @date }

  describe "mixins" do
    it "should include the single answer mixin"
  end

  # instance methods
  it { should respond_to :get_date_or_today }
  describe ".get_date_or_today" do
    it "should return the inputted date"
    it "should return today if the inputted date is empty"
  end

  describe ".form_partial_locals" do
    it "should call super"
    it "should include start year and default in the output"
  end
end
