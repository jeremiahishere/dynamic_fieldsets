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
      "/dynamic_fieldsets/form_partials/" + self.class.gsub("DynamicFieldsets::", "").underscore
    end

    # @return [Hash] Data needed for the form partial
    def form_partial_locals(args)
      {
        :name => "fsa-#{args[:fsa].id}[field-#{args[:fieldset_child].id}]",
        :attrs => self.html_attribute_hash
      }
    end

    # @return [String] Name of partial to render for the show page
    def show_partial
      "/dynamic_fieldsets/show_partials/" + self.class.gsub("DynamicFieldsets::", "").underscore
    end

    # @return [Boolean] Whether to use the included header and footer partials or nothing, leaving you on your with form html
    def use_default_header_and_footer_partials?
      return true
    end

    # @return [Hash] A hash of html attribute key: value pairs
    def html_attribute_hash
      attrs = { :id => "field-#{field.id}-child-#{fieldset_child.id}" }
      field.field_html_attributes.each{ |a| attrs.merge! a.attribute_name.to_sym => a.value } if !field.field_html_attributes.empty?
      return attrs
    end

    # @return [Boolean] True if there are any field records for the field or if it is in any fieldsets
    def in_use?
      self.fieldset_children.count { |child| !child.fieldset_id.nil? || !child.field_records.empty? } > 0
    end
  end
end
