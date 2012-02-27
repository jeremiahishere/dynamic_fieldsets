require 'spec_helper'

describe DynamicFieldsets::FieldsetAssociator do
  include FieldsetAssociatorHelper
  
  it "should respond to fieldset" do
    DynamicFieldsets::FieldsetAssociator.new.should respond_to :fieldset
  end

  it "should respond to field_records" do
    DynamicFieldsets::FieldsetAssociator.new.should respond_to :field_records
  end

  describe "validations" do
    before(:each) do
      @fsa = DynamicFieldsets::FieldsetAssociator.new
    end

    it "should be valid" do
      @fsa.attributes = valid_attributes
      @fsa.should be_valid
    end

    it "should require a fieldset" do
      @fsa.should have(1).error_on(:fieldset_id)
    end

    it "should require a field model id" do
      @fsa.should have(1).error_on(:fieldset_model_id)
    end

    it "should require a field model type" do
      @fsa.should have(1).error_on(:fieldset_model_type)
    end

    it "should require a field model name" do
      @fsa.should have(1).error_on(:fieldset_model_name)
    end

    it "should error require a unique field model, field model name pair" do
      @fsa.attributes = valid_attributes
      @fsa.save
      fsa2 = DynamicFieldsets::FieldsetAssociator.new
      fsa2.should have(1).error_on(:fieldset_model_name)
    end
  end

  describe "find_by_fieldset_model_parameters" do
    before(:each) do
      @fieldset = mock_model(DynamicFieldsets::Fieldset)
      @fieldset.stub!(:nkey).and_return(":hire_form")
      @fieldset.stub!(:id).and_return(1)
      @fsa = DynamicFieldsets::FieldsetAssociator.create(valid_attributes)

      @fieldset_model_attributes = valid_attributes
      @fieldset_model_attributes[:fieldset] = :hire_form
    end
  
    it "should respond to find_by_fieldset_model_parameters" do
      DynamicFieldsets::FieldsetAssociator.should respond_to :find_by_fieldset_model_parameters
    end

    it "should call DynamicFieldsets::Fieldset find_by_nkey" do
      DynamicFieldsets::Fieldset.should_receive(:find_by_nkey).and_return(@fieldset)
      DynamicFieldsets::FieldsetAssociator.find_by_fieldset_model_parameters(@fieldset_model_attributes)
    end

    it "should throw an error if the fieldset does not exist" do
      DynamicFieldsets::Fieldset.stub!(:find_by_nkey).and_return(nil)
      lambda { DynamicFieldsets::FieldsetAssociator.find_by_fieldset_model_parameters(@fieldset_model_attributes) }.should raise_error
    end

    it "should return the correct fieldset associator" do
      DynamicFieldsets::Fieldset.stub!(:find_by_nkey).and_return(@fieldset)
      # this is a fun hack because of all the fsas being made during tests
      DynamicFieldsets::FieldsetAssociator.find_by_fieldset_model_parameters(@fieldset_model_attributes).should include @fsa
    end
  end

  describe "field_values method" do
    before(:each) do
      pending "this method was completely rewritten.  Most of the functionality was moved to other models."
      @fsa = DynamicFieldsets::FieldsetAssociator.new

      @field = mock_model DynamicFieldsets::Field
      @fieldset_child = mock_model DynamicFieldsets::FieldsetChild
      @fieldset_child.stub!(:child).and_return @field
      @fieldset_child.stub!(:id).and_return 37

      @field_record = mock_model DynamicFieldsets::FieldRecord
      @field_record.stub!(:fieldset_child).and_return @fieldset_child
      @field_record.stub!(:value).and_return 42

      @fsa.stub!(:field_records).and_return [@field_record, @field_record]
    end

    it "returns a hash" do
      @fieldset_child.child.stub!(:type).and_return ''
      @fsa.field_values.should be_a_kind_of Hash
    end

    it "calls field_records" do
      @fsa.should_receive(:field_records).and_return []
      @fsa.field_values
    end

    # I am aware these two tests aren't really realistic because ids should be different
    # Results should be consistent with these when ids are different
    it "returns multiple select values as an array of ids" do
      @fieldset_child.child.stub!(:type).and_return 'multiple_select'
      @fsa.field_values.should == { 37 => [42, 42] }
    end

    it "returns checkboxes values as an array of ids" do
      @field.stub!(:type).and_return 'checkbox'
      @fsa.field_values.should == { 37 => [42, 42] }
    end

    it "returns select values as an id" do
      @field.stub!(:type).and_return 'select'
      @fsa.field_values.should == { 37 => 42 }
    end

    it "returns radio values as an id" do
      @field.stub!(:type).and_return 'radio'
      @fsa.field_values.should == { 37 => 42 }
    end

    it "returns all other field types as strings" do
      @field.stub!(:type).and_return 'textfield'
      @field_record.stub!(:value).and_return 'forty two'
      @fsa.field_values.should == { 37 => "forty two" }
    end
  end

  # these tests seem silly when they don't hit the database
  describe "field_records_by_field_name method" do
    before(:each) do
      @fieldset = DynamicFieldsets::Fieldset.new
      @field = DynamicFieldsets::Field.new(:name => "test_field")
      @child = DynamicFieldsets::FieldsetChild.new(:fieldset => @fieldset, :child => @field)

      @fsa = DynamicFieldsets::FieldsetAssociator.new(:fieldset => @fieldset)
      @record = DynamicFieldsets::FieldRecord.new(:fieldset_child => @child)

      @fsa.stub!(:field_records).and_return([@record])
    end

    it "should return a field record if it matches the input" do
      @fsa.field_records_by_field_name("test_field").should include @record
    end

    it "should not return field records that do not match the input" do
      @fsa.field_records_by_field_name("a_different_field").should_not include @record
    end
  end

  describe "dependency_child_hash and look_for_dependents" do
    before(:each) do
      @fsa = DynamicFieldsets::FieldsetAssociator.new

      @fieldset1 = DynamicFieldsets::Fieldset.new
      @fieldset1.stub!(:id).and_return(100)
      @fieldset2 = DynamicFieldsets::Fieldset.new
      @fieldset2.stub!(:id).and_return(200)

      @field1 = DynamicFieldsets::Field.new
      @field1.stub!(:id).and_return(100)
      @field2 = DynamicFieldsets::Field.new
      @field2.stub!(:id).and_return(200)

      @fsa.stub!(:fieldset_id).and_return(100)
      @fsa.stub!(:fieldset).and_return(@fieldset1)

      @fsc1 = DynamicFieldsets::FieldsetChild.new
      @fsc1.stub!(:id).and_return(100)
      @fsc1.stub!(:fieldset_id).and_return(@fieldset1.id)
      @fsc1.stub!(:child_id).and_return(@fieldset2.id)
      @fsc1.stub!(:child_type).and_return("DynamicFieldsets::Fieldset")
      @fsc1.stub!(:child).and_return(@fieldset2)
      @fieldset1.stub!(:fieldset_children).and_return([@fsc1])

      @fsc2 = DynamicFieldsets::FieldsetChild.new
      @fsc2.stub!(:id).and_return(200)
      @fsc2.stub!(:fieldset_id).and_return(@fieldset2.id)
      @fsc2.stub!(:child_id).and_return(@field1.id)
      @fsc2.stub!(:child_type).and_return("DynamicFieldsets::Field")
      @fsc2.stub!(:child).and_return(@field1)

      @fsc3 = DynamicFieldsets::FieldsetChild.new
      @fsc3.stub!(:id).and_return(300)
      @fsc3.stub!(:fieldset_id).and_return(@fieldset2.id)
      @fsc3.stub!(:child_id).and_return(@field2.id)
      @fsc3.stub!(:child_type).and_return("DynamicFieldsets::Field")
      @fsc3.stub!(:child).and_return(@field2)

      @fieldset2.stub!(:fieldset_children).and_return([@fsc2, @fsc3])

      @group = DynamicFieldsets::DependencyGroup.new
      @group.stub!(:id).and_return(100)
      @group.stub!(:fieldset_child_id).and_return(@fsc3.id)
      @group.stub!(:fieldset_child).and_return(@fsc3)
      @group.stub!(:action).and_return("show")

      @clause = DynamicFieldsets::DependencyClause.new
      @clause.stub!(:id).and_return(100)
      @clause.stub!(:dependency_group).and_return(@group)
      @clause.stub!(:dependency_group_id).and_return(@group.id)
      @group.stub!(:dependency_clauses).and_return([@clause])

      @dependency = DynamicFieldsets::Dependency.new
      @dependency.stub!(:id).and_return(100)
      @dependency.stub!(:value).and_return(5)
      @dependency.stub!(:relationship).and_return("equals")
      @dependency.stub!(:dependency_clause).and_return(@clause)
      @dependency.stub!(:dependency_clause_id).and_return(@clause.id)
      @dependency.stub!(:fieldset_child).and_return(@fsc2)
      @dependency.stub!(:fieldset_child_id).and_return(@fsc2.id)
      @fsc2.stub!(:dependencies).and_return([@dependency])
      @clause.stub!(:dependencies).and_return([@dependency])
    end

    # The next two tests are specifically for look_for_dependents

    it "should update the correct array" do
      pending
      @fieldset_child_collection = []
      look_for_dependents(@fieldset1)
      @fieldset_child_collection.empty?.should be_false
    end

    it "should update the array to appropriate value" do
      pending
      @fieldset_child_collection = []
      expected_results = [@fsc2]
      look_for_dependents(@fieldset1)
      @fieldset_child_collection.should == expected_results
    end 

    # The next few tests are specifically for dependency_child_hash

    it "should return a hash" do
      stub!(:look_for_dependents).and_return([@fsc1])
      @fsa.dependency_child_hash.should be_a_kind_of Hash
    end

    it "should have a precise response" do
      stub!(:look_for_dependents).and_return([@fsc1])
      expected_results = {
        @fsc2.id => {
          @group.id => {
            "action" => "show",
            "fieldset_child_id" => @fsc3.id,
            "field_id" => @field2.id,
            "clause" => {
              @clause.id => {
                  @dependency.id => {
                    "fieldset_child_id" => @fsc2.id,
                    "relationship" => "equals",
                    "value" => 5
                  }
              }
            }
          }
        }
      }
      @fsa.dependency_child_hash.should == expected_results
    end
  end
end
