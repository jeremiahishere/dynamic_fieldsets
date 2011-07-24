require 'spec_helper'
include DynamicFieldsets

describe FieldsetAssociator do
  
  it "should respond to fieldset"

  describe "validations" do
    before(:each) do
      @fsa = FieldsetAssociator.new
    end

    it "should be valid"
    it "should require a fieldset"
    it "should require a field model id"
    it "should require a field model type"
    it "should require a field model name"
    it "should error require a unique field model, field model name pair"
  end
end
