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

  describe "run_validations! method" do
    before(:each) do
      @information_form = InformationForm.new
      @information_form.stub!(:run_dynamic_fieldset_validations!)
    end

    it "should call run_dynamic_fieldset_validations!" do
      @information_form.should_receive(:run_dynamic_fieldset_validations!)
      @information_form.run_validations!
    end
  end

  describe "run_dynamic_fieldset_validations! method" do
    before(:each) do
      @field = Field.new(:name => "Test Field", :label => "Test Field", :field_type => "textfield")
      @fieldset = Fieldset.new(:name => "first", :nkey => "first", :description => "description")
      @fieldset.stub!(:children).and_return([@field])
      @fsa = FieldsetAssociator.new
      @fsa.stub!(:fieldset).and_return(@fieldset)
      @fsa.stub!(:id).and_return(1)

      @information_form = InformationForm.new
      @information_form.stub!(:run_fieldset_child_validations!)
      @information_form.stub!(:fieldset_associator).and_return(@fsa)
    end

    it "should iterate over dynamic_fieldset keys" do
      @information_form.dynamic_fieldsets.should_receive(:keys).and_return([])
      @information_form.run_dynamic_fieldset_validations!
    end

    it "should call run_fieldset_child_validations for each key" do
      @information_form.stub!(:dynamic_fieldset_values).and_return({"fsa-1" => { :fieldset_model_name => :child_form }})
      @information_form.should_receive(:run_fieldset_child_validations!)
      @information_form.run_dynamic_fieldset_validations!
    end
  end

  describe "run_fieldset_child_validations! method" do
    before(:each) do
      @field = Field.new(:name => "Test Field", :label => "Test Field", :field_type => "textfield", :required => true)
      @field.stub!(:id).and_return(42)
      @fieldset = Fieldset.new(:name => "first", :nkey => "first", :description => "description")
      @fieldset.stub!(:children).and_return([@field])
      @fsa = FieldsetAssociator.new
      @fsa.stub!(:fieldset).and_return(@fieldset)
      @fsa.stub!(:id).and_return(1)

      @information_form = InformationForm.new
    end

    it "should recurse if the child is a field" do
      values = { "fsa-1" => { "field-42"=>[] } }
      @information_form.stub!(:dynamic_fieldset_values).and_return(values)
      @fieldset.should_receive(:children).and_return([@field])
      @information_form.run_fieldset_child_validations!(@fsa.id, @fieldset)
    end

    it "should add an error if there is no matching field in self.dynamic_fieldset_values" do
      values = { "fsa-1" => { "field-4200"=>"" } }
      @information_form.stub!(:dynamic_fieldset_values).and_return(values)
      @information_form.run_fieldset_child_validations!(@fsa.id, @field)
      @information_form.errors[:base].should include "Test Field is missing from the form data"
    end

    it "should add an error if the field is required, the value is an array, and the value is empty" do
      values = { "fsa-1" => { "field-42"=>[] } }
      @information_form.stub!(:dynamic_fieldset_values).and_return(values)
      @information_form.run_fieldset_child_validations!(@fsa.id, @field)
      @information_form.errors[:base].should include "Test Field is required"
    end

    it "should add an error if the field is required, the value is not an array, and the value is an empty string" do
      values = { "fsa-1" => { "field-42"=>"" } }
      @information_form.stub!(:dynamic_fieldset_values).and_return(values)
      @information_form.run_fieldset_child_validations!(@fsa.id, @field)
      @information_form.errors[:base].should include "Test Field is required"
    end

    it "should add an error if the field is required, the value is not an array, and the value is a nil" do
      values = { "fsa-1" => { "field-42"=>nil } }
      @information_form.stub!(:dynamic_fieldset_values).and_return(values)
      @information_form.run_fieldset_child_validations!(@fsa.id, @field)
      @information_form.errors[:base].should include "Test Field is required"
    end

    it "should not add an error if the field is not required" do
      @field.required = false

      values = { "fsa-1" => { "field-42"=>"" } }
      @information_form.stub!(:dynamic_fieldset_values).and_return(values)
      @information_form.run_fieldset_child_validations!(@fsa.id, @field)
      @information_form.errors.should == {}
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
      @model.stub!(:id).and_return(1234)
      @model.stub!(:dynamic_fieldsets).and_return({:child_form => {:fieldset => :fingerprint_form}})
      @fsa = DynamicFieldsets::FieldsetAssociator.new(:fieldset_model_id => @model.id, :fieldset_model_type => "InformationForm", :fieldset_model_name => :child_form)
      DynamicFieldsets::FieldsetAssociator.stub!(:find_by_fieldset_model_parameters).and_return(@fsa)
    end

    it "should return the fieldset associator object for the specified dynamic fieldset" do
      DynamicFieldsets::FieldsetAssociator.should_receive(:find_by_fieldset_model_parameters).and_return([@fsa])
      @model.fieldset_associator(:child_form).should == @fsa
    end

    it "should make a new fieldset associator object if one does not exist" do
      DynamicFieldsets::FieldsetAssociator.stub!(:find_by_fieldset_model_parameters).and_return([])
      DynamicFieldsets::FieldsetAssociator.stub!(:create).and_return(@fsa)

      # new has been called on the object with specific parameters
      # but it does not match the fsa object because it has a different object id
      new_fsa = @model.fieldset_associator(:child_form)
      new_fsa.fieldset_model_id.should == @model.id
      new_fsa.fieldset_model_type.should == "InformationForm"
      new_fsa.fieldset_model_name.should == "child_form"
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
  
  # values = 
  # {"fsa-1"=>{"field-19"=>"Blahfaceee", "field-20"=>"8", "field-21"=>"No...",
  # "field-22"=>["9"], "field-24"=>"10", "field-17(1i)"=>"1952", "field-17(2i)"=>"2",
  # "field-17(3i)"=>"24", "field-18"=>["4", "5"]}}
  describe "save_dynamic_fieldset method" do
    before(:each) do
      values = { "fsa-1" => { "field-42"=>"testing" } }
      @model = InformationForm.new
      @model.stub!(:dynamic_fieldset_values).and_return values
    end
    
    it "calls dynamic_fieldset_values" do
      @model.should respond_to :dynamic_fieldset_values
    end
    
  end
  
end
