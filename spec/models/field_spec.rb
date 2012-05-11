require 'spec_helper'

describe DynamicFieldsets::Field do
  include FieldHelper

  before do
    @field = DynamicFieldsets::Field.new
  end
  subject { @field }

  describe "fields" do
    it { should respond_to :name }
    it { should respond_to :label }
    it { should respond_to :type }
    it { should respond_to :required }
    it { should respond_to :enabled }
  end

  describe "validations" do
    before(:each) do
      @field = DynamicFieldsets::Field.new
    end

    it "should not be valid because it should be instantiated through the child classes" do
      @field.attributes = valid_attributes
      @field.should_not be_valid
    end

    it "should require name" do
      @field.should have(1).error_on(:name)
    end
    
    it "should require label" do
      @field.should have(1).error_on(:label)
    end

    it "should require type" do
      @field.should have(1).error_on(:type)
    end

    it "should require enabled true or false" do
      @field.enabled = true
      @field.should have(0).error_on(:enabled)
    end

    it "should require required true or false" do
      @field.required = false
      @field.should have(0).error_on(:required)
    end
  end

  # Scopes and Static Methods

  it { DynamicFieldsets::Field.should respond_to :descendants }
  describe ".descendants" do
    it "should call super if cache classes is on" do
      ::Rails.application.config.stub(:cache_classes).and_return(true)
      ActiveRecord::Base.should_receive(:descendants)
      DynamicFieldsets::Field.descendants
    end

    it "should not call super if cache classes is off" do
      ::Rails.application.config.stub(:cache_classes).and_return(false)
      ActiveRecord::Base.should_not_receive(:descendants)
      DynamicFieldsets::Field.descendants
    end

    it "should call the config if cache classes is off" do
      ::Rails.application.config.stub(:cache_classes).and_return(false)
      DynamicFieldsets.config.should_receive(:available_field_types).and_return([])
      DynamicFieldsets::Field.descendants
    end
  end

  it { DynamicFieldsets::Field.should respond_to :descendant_collection }
  describe ".descendant_collection" do
    it "should call descendants" do
      DynamicFieldsets::Field.should_receive(:descendants).and_return([])
      DynamicFieldsets::Field.descendant_collection
    end

    it "should convert the class names to humanized strings" do
      output = DynamicFieldsets::Field.descendant_collection
      output.should include ["Checkbox field", "DynamicFieldsets::CheckboxField"]
      output.should include ["Text field", "DynamicFieldsets::TextField"]
    end
  end

  describe ".display_type" do
    it "should humanize and remove the namespace" do
      @field.stub(:type).and_return("DynamicFieldsets::TextField")
      @field.display_type.should == "Text field"
    end
  end

  describe "form partial methods" do
    it { should respond_to :form_partial }
    describe ".form_partial" do
      it "should use the underscored model name" do
        @field.form_partial.should == "/dynamic_fieldsets/form_partials/field"
      end
    end

    it { should respond_to :form_header_partial }
    describe ".form_header_partial" do
      it "should use the generic input_header partial" do
        @field.form_header_partial.should == "/dynamic_fieldsets/form_partials/input_header"
      end
    end

    it { should respond_to :use_form_header_partial? }
    describe ".use_form_header_partial?" do
      it "should default to true" do
        @field.use_form_header_partial?.should be_true
      end
    end

    it { should respond_to :form_footer_partial }
    describe ".form_footer_partial" do
      it "should use the generic input_footer partial" do
        @field.form_footer_partial.should == "/dynamic_fieldsets/form_partials/input_footer"
      end
    end

    it { should respond_to :use_form_footer_partial? }
    describe ".use_form_footer_partial?" do
      it "should default to true" do
        @field.use_form_footer_partial?.should be_true
      end
    end

    it { should respond_to :form_partial_locals }
    describe ".form_partial_locals" do
      before(:each) do
        @fsa = DynamicFieldsets::FieldsetAssociator.new
        @fsa.stub(:id).and_return(1)

        @fieldset_child = DynamicFieldsets::FieldsetAssociator.new
        @fieldset_child.stub(:id).and_return(2)

        @arguments = {
          :fsa => @fsa,
          :fieldset_child => @fieldset_child,
        }
      end

      it "should include these keys in the output" do
        output = @field.form_partial_locals(@arguments)
        expected_keys = [:fsa, :fieldset_child, :attrs, :object, :method, :name, :id]
        expected_keys.each do |key|
          output.keys.should include key
        end
      end

      it "fsa should match the fsa in the args" do
        output = @field.form_partial_locals(@arguments)
        output[:fsa] = @fsa
      end

      it "fieldset_child should match the fieldset_child in the args" do
        output = @field.form_partial_locals(@arguments)
        output[:fieldset_child] = @fieldset_child
      end

      it "attrs should call html_attribute_hash" do
        @field.should_receive(:html_attribute_hash).and_return({:hello => "world"})
        output = @field.form_partial_locals(@arguments)
        output[:attrs].should == {:hello => "world"}
      end

      it "object should use the config option and fsa id" do
        DynamicFieldsets::config.should_receive(:form_fieldset_associator_prefix).and_return("hello")
        @fsa.should_receive(:id).and_return(10)

        output = @field.form_partial_locals(@arguments)
        output[:object].should == "hello10"
      end

      it "method should use the config option and fieldset child id" do
        DynamicFieldsets::config.should_receive(:form_field_prefix).and_return("hello")
        @fieldset_child.should_receive(:id).and_return(10)

        output = @field.form_partial_locals(@arguments)
        output[:method].should == "hello10"
      end 

      it "name should match object[method]" do
        output = @field.form_partial_locals(@arguments)
        output[:name].should == "#{output[:object]}[#{output[:method]}]"
      end

      it "id should match object_method" do
        output = @field.form_partial_locals(@arguments)
        output[:id].should == "#{output[:object]}_#{output[:method]}"
      end
    end

    it { should respond_to :html_attribute_hash }
    describe ".html_attribute_hash" do
      it "should call field_html_attributes" do
        @field.should_receive(:field_html_attributes).and_return([])
        @field.html_attribute_hash
      end

      it "should pull the attribute names and values and put them in a hash" do
        @attr = DynamicFieldsets::FieldHtmlAttribute.new
        @attr.stub(:attribute_name => "key")
        @attr.stub(:value => "value")

        @field.stub(:field_html_attributes).and_return([@attr])
        @field.html_attribute_hash.should == {:key => "value"}
      end
    end
  end

  describe "show partial methods" do

    it { should respond_to :show_partial }
    describe ".show_partial" do
      it "should default to the missing partial partial" do
        @field.show_partial.should == "/dynamic_fieldsets/show_partials/show_incomplete"
      end
    end

    it { should respond_to :show_header_partial }
    describe ".show_header_partial" do
      it "should default to the incomplete header partial" do
        @field.show_header_partial.should == "/dynamic_fieldsets/show_partials/show_incomplete_header"
      end
    end

    it { should respond_to :use_show_header_partial? }
    describe ".use_show_header_partial?" do
      it "should default to false" do
        @field.use_show_header_partial?.should be_false
      end
    end

    it { should respond_to :show_footer_partial }
    describe ".show_footer_partial" do
      it "should default to the incomplete footer partial" do
        @field.show_footer_partial.should == "/dynamic_fieldsets/show_partials/show_incomplete_footer"
      end
    end

    it { should respond_to :use_show_footer_partial? }
    describe ".use_show_footer_partial?" do
      it "should default to false" do
        @field.use_show_footer_partial?.should be_false
      end
    end

    it { should respond_to :show_partial_locals }
    describe ".show_partial_locals" do
      before(:each) do
        @arguments = { 
          :value => "hello",
          :value => ["hello", "world"]
        }
      end
      
      it "should include value in the output" do
        output = @field.show_partial_locals(@arguments)
        output[:value].should == @arguments[:value]
      end

      it "should include values in the output" do
        output = @field.show_partial_locals(@arguments)
        output[:values].should == @arguments[:values]
      end

      it "should call label and include it in the output" do
        @field.should_receive(:label).and_return("hello")
        output = @field.show_partial_locals(@arguments)
        output[:label].should == "hello"
      end
    end

    # note that this gets overriden based on the number of answers
    it { should respond_to :get_value_for_show }
    describe ".get_value_for_show" do
      it "should return nil if the value is nil" do
        @field.get_value_for_show(nil).should be_nil
      end

      it "should return the value of the value key otherwise" do
        val = { :value => "hello" }
        @field.get_value_for_show(val).should == "hello"
      end
    end
  end

  # other methods

  it { should respond_to :has_defaults? }
  describe "has_defaults?" do
    before(:each) do
      @field = DynamicFieldsets::Field.new
    end

    it "should return true if the field default has a value" do
      @field.should_receive(:field_defaults).and_return(["default value"])
      @field.has_defaults?.should be_true
    end

    it "should return false if the field default has no values" do
      @field.should_receive(:field_defaults).and_return([])
      @field.has_defaults?.should be_false
    end
  end

  it { should respond_to :in_use? }
  describe "in_use? method" do
    before(:each) do
      @field = DynamicFieldsets::Field.new
      @field.stub!(:id).and_return(1)

    end
    it "should return true if there is a field record associated with the field" do
      @fieldset_child = DynamicFieldsets::FieldsetChild.new(:child => @field, :fieldset => nil )
      @fieldset_child.stub!(:field_records).and_return(["random", "array" "of", "stuff"])
      @field.stub!(:fieldset_children).and_return([@fieldset_child])

      @field.in_use?.should be_true
    end

    it "should return true if the field is in a fieldset (through a fieldset child)" do
      @fieldset = DynamicFieldsets::Fieldset.new
      @fieldset.stub!(:id).and_return(2)
      @fieldset_child = DynamicFieldsets::FieldsetChild.new(:child => @field, :fieldset_id => @fieldset.id)
      @field.stub!(:fieldset_children).and_return([@fieldset_child])

      @field.in_use?.should be_true
    end

    it "should return false otherwise" do
      @field.in_use?.should be_false
    end
  end

  it { should respond_to :uses_field_options? }
  describe ".uses_field_options?" do
    it "should return false" do
      @field.uses_field_options?.should be_false
    end
  end

  it { should respond_to :collect_default_values }
  describe ".collect_default_values" do
    it "should call field_defaults" do
      @field.should_receive(:field_defaults).and_return([])
      @field.collect_default_values
    end

    it "should collect the values of the returned defaults" do
      @field.stub(:field_defaults).and_return([{:value => "hello" }])
      @field.collect_default_values.should == ["hello"]
    end
  end

  it { should respond_to :get_values_using_fsa_and_fsc }
  describe ".get_values_using_fsa_and_fsc" do
    it "should return nil (must be overriden)" do
      # just passing nils because the args are not needed in the test
      @field.get_values_using_fsa_and_fsc(nil, nil).should be_nil
    end
  end

  it { should respond_to :collect_field_records_by_fsa_and_fsc }
  describe ".collect_field_records_by_fsa_and_fsc" do
    it "should return an array of field record values" do
      record = mock_model(DynamicFieldsets::FieldRecord)
      record.stub(:value).and_return("hello")

      DynamicFieldsets::FieldRecord.stub!(:where).and_return([record])

      fsa = mock_model(DynamicFieldsets::FieldsetAssociator)
      fsc = mock_model(DynamicFieldsets::FieldsetChild)
      @field.collect_field_records_by_fsa_and_fsc(fsa, fsc).should == [{ :value => "hello" }]
    end
  end

  it { should respond_to :update_field_records }
  describe ".update_field_records" do
    it "should throw an error" do
      lambda { @field.update_field_records }.should raise_exception
    end
  end
end
