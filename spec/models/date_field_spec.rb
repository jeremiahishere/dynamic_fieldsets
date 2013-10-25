require 'spec_helper'

describe DynamicFieldsets::DateField do
  before do
    @date = DynamicFieldsets::DateField.create(:name => "test", :label => "test")
  end
  subject { @date }

  describe "mixins" do
    it "should include the single answer mixin" do
      @date.class.should respond_to :acts_as_field_with_single_answer
    end
  end

  # instance methods
  it { should respond_to :get_date_or_today }
  describe ".get_date_or_today" do
    it "should return the inputted date" do
      @date.get_date_or_today({:value => "10:10 2013/10/22"}).should == Time.parse("2013-10-22 10:10:00")
    end
    it "should return today if the inputted date is empty" do
      @date.get_date_or_today(nil).should == Date.today
    end
  end

  describe ".form_partial_locals" do
    before (:all) do
      @fsa = DynamicFieldsets::FieldsetAssociator.new
      @fsa.stub!(:id).and_return(1)
      @fsc = DynamicFieldsets::FieldsetChild.new
      @fsc.stub!(:id).and_return(1)
      @attributes = {:fsa => @fsa, :fieldset_child => @fsc, :values => [], :value => nil}
    end
    it "should call super" do
      # fsa and fsc are set in the superclass (Field) form_partial_locals method
      @date.form_partial_locals(@attributes)[:fsa].should == @fsa
      @date.form_partial_locals(@attributes)[:fieldset_child].should == @fsc
    end
    it "should include start year and default in the output" do
      @date.form_partial_locals(@attributes)[:date_options].keys.should == [:start_year, :default]
    end
  end
end
