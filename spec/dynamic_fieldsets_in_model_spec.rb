require 'spec_helper'

include DynamicFieldsets

describe DynamicFieldsetsInModel do

  it "should respond to acts_as_dynamic_fieldset" do
    InformationForm.should respond_to :acts_as_dynamic_fieldset
  end

  it "should respond to fieldset_associator" do
    InformationForm.new.should respond_to :fieldset
  end

  it "should respond to fieldset" do
    InformationForm.new.should respond_to :fieldset_associator
  end

  describe "acts_as_dynamic_fieldset class method" do
    before(:each) do
      @model = InformationForm.new
    end

    it "should initialize the dynamic_fieldsets field" do
      @model.should respond_to :dynamic_fieldsets
    end

    it "should include the instance methods" do
      @model.should be_a_kind_of (DynamicFieldsets::DynamicFieldsetsInModel::InstanceMethods)
    end
  end

  describe "method missing method" do
    before(:each) do
      @model = InformationForm.new
      @model.stub!(:fieldset_associator)
      @model.stub!(:fieldset)
    end

    it "should call match_fieldset_associator?" do
      @model.should_receive(:match_fieldset_associator?).and_return(true)
      @model.some_method
    end

    it "should call fieldset_associator if match_fieldset_associator? returns true" do
      @model.stub!(:match_fieldset_associator?).and_return(true)
      @model.should_receive(:fieldset_associator)
      @model.some_method
    end

    it "should call match_fieldset?" do
      @model.stub!(:match_fieldset_associator?).and_return(false)
      @model.should_receive(:match_fieldset?).and_return(true)
      @model.some_method
    end

    it "should call fieldset if match_fieldset? returns true" do
      @model.stub!(:match_fieldset_associator?).and_return(false)
      @model.stub!(:match_fieldset?).and_return(true)
      @model.should_receive(:fieldset)
      @model.some_method
    end
  end

  describe "respond_to? method" do
    before(:each) do
      @model = InformationForm.new
    end

    it "should call match_fieldset_associator?" do
      @model.should_receive(:match_fieldset_associator?)
      @model.respond_to?(:some_method)
    end

    it "should call match_fieldset?" do
      @model.stub!(:match_fieldset_associator?).and_return(false)
      @model.should_receive(:match_fieldset?)
      @model.respond_to?(:some_method)
    end
  end

  describe "match_fieldset_associator? method" do
    before(:each) do
      @model = InformationForm.new
      @model.stub!(:dynamic_fieldsets).and_return({:child_form => []})
    end

    it "should call dynamic_fieldsets" do
      @model.should_receive(:dynamic_fieldsets).and_return({:child_form => []})
      @model.match_fieldset_associator?(:some_method)
    end

    it "should return true if the sym parameter matches a key in dynamic_fieldsets" do
      @model.match_fieldset_associator?(:child_form).should be_true
    end

    it "should return false if the sym parameter does not match a key in dynamic_fieldsets" do
      @model.match_fieldset_associator?(:not_child_form).should be_false
    end
  end

  # need to be abvle to call child_form_fieldset to get the fieldset object
  # because child_form does not exist in the fsa model until after it is created
  describe "match_fieldset? method" do
    before(:each) do
      @model = InformationForm.new
      @model.stub!(:dynamic_fieldsets).and_return({:child_form => []})
    end

    it "should call dynamic_fieldsets if the calling method includes _fieldset" do
      @model.should_receive(:dynamic_fieldsets).and_return({:child_form => []})
      @model.match_fieldset?(:some_method_fieldset)
    end

    it "should return true if the sym parameter matches a key in dynamic_fieldsets followed by the word fieldset" do
      @model.match_fieldset?(:child_form_fieldset).should be_true
    end

    it "should return false if the sym parameter does not match a key in dynamic_fieldsets followed by the word fieldset" do
      @model.match_fieldset?(:not_child_form_fieldset).should be_false
    end

    it "should return false if the sym parameter matches a key in dynamic_fieldsets not followed by the word fieldset" do
      @model.match_fieldset?(:child_form).should be_false
    end
  end

  describe "fieldset_associator method" do
    before(:each) do
      @model = InformationForm.new
      @model.stub!(:dynamic_fieldsets).and_return({:child_form => {:fieldset => :fingerprint_form}})
      @fsa = DynamicFieldsets::FieldsetAssociator.new(:fieldset_model_id => 1234, :fieldset_model_type => "InformationForm", :fieldset_model_name => :child_form)
      DynamicFieldsets::FieldsetAssociator.stub!(:find_by_fieldset_model_parameters).and_return(@fsa)
    end

    it "should return the fieldset associator object for the specified dynamic fieldset" do
      DynamicFieldsets::FieldsetAssociator.should_receive(:find_by_fieldset_model_parameters).and_return([@fsa])
      @model.fieldset_associator(:child_form).should == @fsa
    end

    it "should create a new fieldset associator object if one does not exist" do
      DynamicFieldsets::FieldsetAssociator.stub!(:find_by_fieldset_model_parameters).and_return([])
      DynamicFieldsets::FieldsetAssociator.stub!(:create).and_return(@fsa)

      # don't know why I need this, should be handled by the create stub
      @model.fieldset_associator(:child_form).should == @fsa
    end

    it "should return nil if the sym param does not match a key in the dynamic_fieldsets field" do
      @model.fieldset_associator(:not_child_form).should be_nil
    end
  end

  describe "fieldset method" do
    before(:each) do
      @model = InformationForm.new
      @model.stub!(:dynamic_fieldsets).and_return({:child_form => {:fieldset => :fingerprint_form}})
      @fieldset = DynamicFieldsets::Fieldset.new(:nkey => :fingerprint_form)
      DynamicFieldsets::Fieldset.stub!(:find_by_nkey).and_return(@fieldset)
    end

    it "should call find_by_nkey for the fieldset model" do
      DynamicFieldsets::Fieldset.should_receive(:find_by_nkey).and_return(@fieldset)
      @model.fieldset(:child_form)
    end

    it "should return the fieldset object for the specified dynamic fieldset" do
      @model.fieldset(:child_form).should == @fieldset
    end
      
    it "should return nil if the sym param does not match a kyer in the dynamic_fieldsets field" do
      @model.fieldset(:not_child_form).should be_nil
    end
  end
  
  # {"fsa-1"=>{"field-19"=>"Blahfaceee", "field-20"=>"8", "field-21"=>"No...",
  # "field-22"=>["9"], "field-24"=>"10", "field-17(1i)"=>"1952", "field-17(2i)"=>"2",
  # "field-17(3i)"=>"24", "field-18"=>["4", "5"]}}
  describe "save_dynamic_fieldset method" do
    before(:each) do
      values = { "fsa-1" => { "field-42" => "testing" } }
      @model = InformationForm.new
      @model.stub!(:dynamic_fieldset_values).and_return values
    end
    
    it "calls dynamic_fieldset_values" do
      @model.should respond_to :dynamic_fieldset_values
    end
    
    it ""
    
  end
  
end
