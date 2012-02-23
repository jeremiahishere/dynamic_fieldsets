module DynamicFieldsets
  # Base class for various fieldtypes, i.e. questions
  #
  # @author Jeremiah Hemphill, Ethan Pemble
  class Field < ActiveRecord::Base
    set_table_name "dynamic_fieldsets_fields"

    # Associations
    
    # parents
    has_many :fieldset_children, :dependent => :destroy, :as => :child
    has_many :parent_fieldsets, :source => :fieldset, :foreign_key => "fieldset_id", :through => :fieldset_children, :class_name => "Fieldset"

    has_many :field_options
    accepts_nested_attributes_for :field_options, :allow_destroy => true

    has_many :field_defaults
    accepts_nested_attributes_for :field_defaults, :allow_destroy => true

    has_many :field_html_attributes
    accepts_nested_attributes_for :field_html_attributes, :allow_destroy => true

    #has_many :dependency_groups
    #accepts_nested_attributes_for :dependency_groups, :allow_destroy => true

    # Validations
    validates_presence_of :name
    validates_presence_of :label
    validates_presence_of :type
    validates_inclusion_of :enabled, :in => [true, false]
    validates_inclusion_of :required, :in => [true, false]

    def self.descendants
      if ::Rails.application.config.cache_classes
        super
      else
        # this needs to be moved to a config somewhere
        [DynamicFieldsets::CheckboxField, DynamicFieldsets::DateField, DynamicFieldsets::DatetimeField, DynamicFieldsets::InstructionField, DynamicFieldsets::MultipleSelectField, DynamicFieldsets::RadioField, DynamicFieldsets::SelectField, DynamicFieldsets::TextField, DynamicFieldsets::TextareaField]
      end
    end
    
    def self.descendant_collection
      descendants.collect { |d| [d.to_s.gsub("DynamicFieldsets::", "").underscore.humanize, d.to_s ] }
    end
    
    # @return [Boolean] False if field_default.value is empty
    def has_defaults?
      return self.field_defaults.length > 0
    end

    # @return [String] Name of partial to render for the form
    def form_partial
      "/dynamic_fieldsets/form_partials/" + self.class.to_s.gsub("DynamicFieldsets::", "").underscore
    end

    # @return [String] Name of the input header for the form
    def form_header_partial
      "/dynamic_fieldsets/form_partials/input_header"
    end

    # @return [Boolean] By default, use the header partial
    def use_form_header_partial?
      true
    end

    # @return [String] Name of the input footer for the form
    def form_footer_partial
      "/dynamic_fieldsets/form_partials/input_footer"
    end

    # @return [Boolean] By default, use the footer partial
    def use_form_footer_partial?
      true
    end

    # @return [Hash] Data needed for the form partial
    def form_partial_locals(args)
      output = {
        :fsa => args[:fsa],
        :fieldset_child => args[:fieldset_child],
        :attrs => self.html_attribute_hash,
        # for use in helpers like text_field and date_select
        :object => "fsa-#{args[:fsa].id}",
        :method => "field-#{args[:fieldset_child].id}",
      }
      # name for use in helpers like select_tag, check_box_tag, or anything ending with _tag
      # this is more of a convenience method
      output[:name] = "#{output[:object]}[#{output[:method]}]"
      output[:id] = "#{output[:object]}_#{output[:method]}"
      return output
    end

    # @return [Hash] A hash of html attribute key: value pairs
    def html_attribute_hash
      attrs = {}
      field_html_attributes.each{ |a| attrs.merge! a.attribute_name.to_sym => a.value } if !field_html_attributes.empty?
      return attrs
    end

    # This method must be overriden
    #
    # @return [String] Name of partial to render for the show page
    def show_partial
      "/dynamic_fieldsets/show_partials/show_incomplete"
    end

    # This method must be overriden if show_header_partial returns true
    #
    # @return [String] Name of the input header for the show
    def show_header_partial
      "/dynamic_fieldsets/show_partials/show_incomplete_header"
    end

    # @return [Boolean] By default, do not use the header partial
    def use_show_header_partial?
      false
    end

    # This method must be overriden if show_footer_partial returns true
    #
    # @return [String] Name of the input footer for the show
    def show_footer_partial
      "/dynamic_fieldsets/show_partials/show_incomplete_footer"
    end

    # @return [Boolean] By default, do not use the footer partial
    def use_show_footer_partial?
      false
    end

    # @return [Hash] Information needed for the show partial, don't know what I need yet
    def show_partial_locals(args)
      # these should be incredibly temporary
      {
        :value => "value",
        :values => ["values"],
        :label => "label"
      }
    end

    # @return [Boolean] True if there are any field records for the field or if it is in any fieldsets
    def in_use?
      self.fieldset_children.count { |child| !child.fieldset_id.nil? || !child.field_records.empty? } > 0
    end

    # Fields such as selects, checkboxes, and radios use predefined field options for their values
    # By default, a field does not use field options
    #
    # @return [Boolean] Whether the field uses field options, defaults to false
    def uses_field_options?
      false
    end

    # this collects defaults so that we can use them for fields
    # note that this should be overriden when the field uses field options
    # in that case, it should return field option ids instead of field option names
    # 
    # I'm sorry
    def collect_default_values
      field_defaults.collect { |d| d[:value] }
    end
  end
end
