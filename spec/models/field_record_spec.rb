require 'spec_helper'
include DynamicFieldsets

describe FieldRecord do
  include FieldRecordHelper

  it "should respond to field"
  it "should respond to fieldset_associator"

  describe "validations" do
    it "should be valid"
    it "should require field"
    it "should require fieldset_associator"
    it "should require value"
    it "should not error if value is a blank string"
    it "should require a unique field, fieldset_associator pair"
  end

end
