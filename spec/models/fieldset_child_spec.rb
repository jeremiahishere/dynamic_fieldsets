require 'spec_helper'

describe DynamicFieldsets::FieldsetChild do
  include FieldsetChildHelper

  before do
    @child = DynamicFieldsets::FieldsetChild.new
  end

  subject { @child }

  describe "fields" do
    it { should respond_to :fieldset_id }
    it { should respond_to :child_id }
    it { should respond_to :child_type }
    it { should respond_to :order_num }
  end

  describe "associations" do
    before do
      pending "can't get shoulda working"
    end
    it { should belong_to :child }
    it { should belong_to :fieldset }
    it { should have_many :field_records }
    it { should have_one :dependency_group }
    it { should have_many :dependencies } 
  end

  describe "validations" do
    before(:each) do
      @fieldset_child = DynamicFieldsets::FieldsetChild.new
    end
    it "are valid" do
      @fieldset_child.attributes = valid_attributes
      @fieldset_child.should be_valid
    end
    
    it "require fieldset" do
      @fieldset_child.should have(1).error_on(:fieldset_id)
    end

    it "require child" do
      @fieldset_child.should have(1).error_on(:child_id)
      @fieldset_child.should have(1).error_on(:child_type)
    end

    it "require order_num" do
      @fieldset_child.stub!(:assign_order)
      @fieldset_child.should have(1).error_on(:order_num)
    end

    describe "validates includsion of child type" do
      it "should allow a child type of 'DynamicFieldsets::Field'" do
        @fieldset_child.child_type = "DynamicFieldsets::Field"
        @fieldset_child.should have(0).error_on(:child_type)
      end

      it "should allow a child type of 'DynamicFieldsets::Fieldset'" do
        @fieldset_child.child_type = "DynamicFieldsets::Fieldset"
        @fieldset_child.should have(0).error_on(:child_type)
      end

      it "should not allow a child type if not 'DynamicFieldsets::Field' or 'DynamicFieldsets::Fieldset'" do
        @fieldset_child.child_type = "Not Field or Fieldset"
        @fieldset_child.should have(1).error_on(:child_type)
      end
    end

    it "should call these additional validators" do
      @fieldset_child.should_receive(:no_duplicate_fields_in_fieldset_children)
      @fieldset_child.should_receive(:cannot_be_own_parent)
      @fieldset_child.should_receive(:no_parental_loop)
      @fieldset_child.valid?
    end
 
    # no_duplicate_fields_in_fieldset_children
    it "should not allow duplicate pairings of fieldsets and fields" do
      fieldset = DynamicFieldsets::Fieldset.create
      field = DynamicFieldsets::Field.create
      fieldset_child1 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => fieldset.id, :child_id => field.id, :order_num => 1, :child_type => "DynamicFieldsets::Field")
      fieldset_child2 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => fieldset.id, :child_id => field.id, :order_num => 2, :child_type => "DynamicFieldsets::Field")
      fieldset_child2.should have(1).error_on(:child_id)
    end

    # cannot_be_own_parent
    # this should have two errors, because it's also a loop
    it "cannot be it's own parent" do
      fieldset = DynamicFieldsets::Fieldset.new
      fieldset.stub!(:id).and_return(100)
      fieldset_child = DynamicFieldsets::FieldsetChild.new(:fieldset_id => fieldset.id, :child_id => fieldset.id, :order_num => 1, :child_type => "DynamicFieldsets::Fieldset")
      fieldset_child.should have(2).error_on(:child_id)
    end
  
    # no_parental_loop
    it "should not allow a parent fieldset when it would create a cycle" do
      fieldset1 = DynamicFieldsets::Fieldset.new
      fieldset1.stub!(:id).and_return(100)
      fieldset2 = DynamicFieldsets::Fieldset.new
      fieldset2.stub!(:id).and_return(200)
      fieldset3 = DynamicFieldsets::Fieldset.new
      fieldset3.stub!(:id).and_return(300)
      fieldset_child1 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => fieldset1.id, :child => fieldset2, :order_num => 1)
      fieldset_child2 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => fieldset2.id, :child => fieldset3, :order_num => 1)
      fieldset_child3 = DynamicFieldsets::FieldsetChild.new(:fieldset_id => fieldset3.id, :child => fieldset1, :order_num => 1)
      fieldset_child3.should have(1).error_on(:child_id)
    end
  end

  # Scopes and static methods
  it { DynamicFieldsets::FieldsetChild.should respond_to(:ordered) }
  describe ".ordered scope" do
    it "needs tests"
  end

  # Methods

  it { should respond_to :children }
  describe ".children" do
    it "needs tests"
  end

  it { should respond_to :fieldset_child_list }
  describe ".fieldset_child_list" do
    it "should match the constant FIELDSET_CHILD_LIST" do
      @child.fieldset_child_list.should == DynamicFieldsets::FieldsetChild::FIELDSET_CHILD_LIST
    end
  end

  it { should respond_to :get_value_using_fsa }
  describe ".get_value_using_fsa" do
    it "needs tests"
  end

  it { should respond_to :last_order_num }
  describe ".last_order_num" do
    it "needs tests"
  end

  describe "root_fieldset method" do
    before(:each) do
      # too many issues with stubbing, getting lazy and saving
      # could be refactored at some point

      @field = DynamicFieldsets::Field.create({ :name => "Test field name", :label => "Test field label", :type => "textfield", :required => true, :enabled => true, })
      @fieldset = DynamicFieldsets::Fieldset.create({:name => "Hire Form", :description => "Hire a person for a job", :nkey => "hire_form"})
      @root_fieldset = DynamicFieldsets::Fieldset.create({:name => "Hire Form2", :description => "Hire a person for a job2", :nkey => "hire_form2"})

      @field_child = DynamicFieldsets::FieldsetChild.create(:child => @child, :fieldset => @fieldset, :order_num => 1)
      @child = DynamicFieldsets::FieldsetChild.create(:child => @fieldset, :fieldset => @root_fieldset, :order_num => 2)
    end
    it "should return a fieldset if it is not present as the child in fieldset child" do
      @child.root_fieldset.should == @root_fieldset
    end

    it "should recurse if the fieldset is present as a child in a fieldset child" do
      @field_child.root_fieldset.id.should == @root_fieldset.id
    end
  end

  it { should respond_to :siblings }
  describe ".siblings" do
    it "needs tests"
  end

  it { should respond_to :to_hash }
  describe "to_hash method" do
    it "needs specs"
    it "needs comments"
  end
end
