require 'spec_helper'

describe DynamicFieldsets::FieldsetChild do
  include FieldsetChildHelper

  before do
    @parent_fieldset = DynamicFieldsets::Fieldset.new
    @parent_fieldset.stub!(:id).and_return(100)
    @child_fieldset = DynamicFieldsets::Fieldset.new
    @child_fieldset.stub!(:id).and_return(200)
    
    @test_child = DynamicFieldsets::FieldsetChild.create(:fieldset_id => @parent_fieldset.id, :child_id => @child_fieldset.id, :child_type => "DynamicFieldsets::Fieldset")
    @test_child.stub!(:child).and_return(@child_fieldset)
    @test_child.stub!(:fieldset).and_return(@parent_fieldset)
    
    field1 = DynamicFieldsets::TextField.create(:name => "test", :label => "test")
    field2 = DynamicFieldsets::TextField.create(:name => "test", :label => "test")
    field3 = DynamicFieldsets::TextField.create(:name => "test", :label => "test")

    @child1 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => @child_fieldset.id, :child_id => field1.id, :child_type => "DynamicFieldsets::Field", :order_num => 1)
    @child2 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => @child_fieldset.id, :child_id => field2.id, :child_type => "DynamicFieldsets::Field", :order_num => 2)
    @child3 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => @child_fieldset.id, :child_id => field3.id, :child_type => "DynamicFieldsets::Field", :order_num => 3)
    
    @sib1 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => @parent_fieldset.id, :child_id => field1.id, :child_type => "DynamicFieldsets::Field", :order_num => 1)
    @sib2 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => @parent_fieldset.id, :child_id => field2.id, :child_type => "DynamicFieldsets::Field", :order_num => 2)
    @sib3 = DynamicFieldsets::FieldsetChild.create(:fieldset_id => @parent_fieldset.id, :child_id => field3.id, :child_type => "DynamicFieldsets::Field", :order_num => 3)
  end

  subject { @test_child }

  describe "fields" do
    it { should respond_to :fieldset_id }
    it { should respond_to :child_id }
    it { should respond_to :child_type }
    it { should respond_to :order_num }
  end

  describe "associations" do
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
      fieldset = DynamicFieldsets::Fieldset.new
      field = DynamicFieldsets::Field.new
      field.stub!(:id).and_return(100)
      fieldset_child1 = DynamicFieldsets::FieldsetChild.new(:fieldset => fieldset, :child => field, :order_num => 1)
      fieldset_child1.stub!(:id).and_return(100)
      fieldset_child2 = DynamicFieldsets::FieldsetChild.new(:fieldset => fieldset, :child => field, :order_num => 2)
      DynamicFieldsets::FieldsetChild.stub!(:where).and_return([fieldset_child1])
      fieldset_child2.should have(1).error_on(:child_id)
    end

    # cannot_be_own_parent
    # this should have two errors, because it's also a loop
    it "cannot be it's own parent" do
      fieldset = DynamicFieldsets::Fieldset.new
      fieldset.stub!(:id).and_return(100)
      fieldset_child = DynamicFieldsets::FieldsetChild.new(:fieldset_id => fieldset.id, :child => fieldset, :order_num => 1)
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
    it "returns fieldset children in ascending order by attribute order_num" do\
      DynamicFieldsets::FieldsetChild.ordered.should == [@test_child,@child1,@sib1,@child2,@sib2,@child3,@sib3]
    end
  end

  # Methods

  it { should respond_to :children }
  describe ".children" do
    it "returns fieldset children that descend from this one" do
      @test_child.children.should == [@child1,@child2,@child3]
    end
  end

  it { should respond_to :fieldset_child_list }
  describe ".fieldset_child_list" do
    it "should match the constant FIELDSET_CHILD_LIST" do
      @test_child.fieldset_child_list.should == DynamicFieldsets::FieldsetChild::FIELDSET_CHILD_LIST
    end
  end

  it { should respond_to :get_value_using_fsa }
  describe ".get_value_using_fsa" do
    it "needs to call get_values_using_fsa if fieldset child is a fieldset" do
      @fsa = DynamicFieldsets::FieldsetAssociator.create(:fieldset_id => @parent_fieldset.id, :fieldset_model_id => 1, :fieldset_model_type => "Test", :fieldset_model_name => "test")

      @test_child.child.should_receive(:get_values_using_fsa).with(@fsa)
      @test_child.get_value_using_fsa(@fsa)
    end
  end

  it { should respond_to :last_order_num }
  describe ".last_order_num" do
    before (:each) do
      @new_field = DynamicFieldsets::TextField.create(:name => "test", :label => "test")
      @new_fieldset = DynamicFieldsets::Fieldset.create(:name => "test", :nkey => "new_fieldset", :description => "test")
      @new_child = DynamicFieldsets::FieldsetChild.create(:fieldset_id => @new_fieldset.id, :child_id => @new_field.id, :child_type => "DynamicFieldsets::Field", :order_num => 1)
    end
    
    it "should return 0 when fieldset child has no siblings" do
      @new_child.last_order_num.should == 0
    end
    
    it "should return last ordered fieldset child otherwise" do
      second_field = DynamicFieldsets::TextField.create(:name => "test", :label => "test")
      second_child = DynamicFieldsets::FieldsetChild.create(:fieldset_id => @new_fieldset.id, :child_id => second_field.id, :child_type => "DynamicFieldsets::Field", :order_num => 2)
      @new_child.last_order_num.should == 2
    end
  end

  describe "root_fieldset method" do
    it "should return a fieldset if it is not present as the child in fieldset child" do
      @test_child.root_fieldset.should == @parent_fieldset
    end

    it "should recurse if the fieldset is present as a child in a fieldset child" do
      @child1.stub!(:fieldset).and_return(@child_fieldset)
      DynamicFieldsets::FieldsetChild.should_receive(:where).with({:child_id => @child_fieldset.id, :child_type => "DynamicFieldsets::Fieldset"}).and_return([@test_child])
      DynamicFieldsets::FieldsetChild.should_receive(:where).with({:child_id => @parent_fieldset.id, :child_type => "DynamicFieldsets::Fieldset"}).and_return([])
      @child1.root_fieldset.should == @parent_fieldset
    end
  end

  it { should respond_to :siblings }
  describe ".siblings" do
    it "return fieldset children that have same parent (not including self)" do
      @test_child.siblings.should == [@sib1, @sib2, @sib3]
    end
  end

  it { should respond_to :to_hash }
  describe "to_hash method" do
    it "returns attributes in a hash" do
      @test_child.to_hash.should == {"id" => @test_child.id, "fieldset_id" => @test_child.fieldset_id, "child_id" => @test_child.child_id, "child_type" => @test_child.child_type}
    end
  end
end
