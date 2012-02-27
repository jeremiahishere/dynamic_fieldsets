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
        DynamicFieldsets.config.available_field_types
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
        :object => "#{DynamicFieldsets::config.form_fieldset_associator_prefix}#{args[:fsa].id}",
        :method => "#{DynamicFieldsets::config.form_field_prefix}#{args[:fieldset_child].id}",
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

    # Note that this method is really weird
    # You would think that the value displayed should be figured out here
    # but instead, it is figured out first, then passed in, in the arguments hash
    #
    # @return [Hash] Information needed for the show partial, don't know what I need yet
    def show_partial_locals(args)
      # these should be incredibly temporary
      {
        :value => args[:value],
        :values => args[:values],
        :label => self.label,
      }
    end

    # given a value hash for a field, return the part that needs to be shown on the show page
    def get_value_for_show(value)
      value[:value]
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
    # note that this should be overridden when the field uses field options
    # in that case, it should return field option ids instead of field option names
    # 
    # I'm sorry
    def collect_default_values
      field_defaults.collect { |d| d[:value] }
    end

    # This method should be overridden by the field subclasses
    #
    # @param [DynamicFieldsets::FieldsetAssociator] fsa The associator
    # @param [DynamicFieldsets::FieldsetChild] fsc The fieldset child
    # @return [Nil] An empty result
    def get_values_using_fsa_and_fsc(fsa, fsc)
      return nil
    end

    # Collects the field records for the field so they can be used on the front end
    # These are only the currently saved values in the database, don't worry 
    # about defaults here
    #
    # This works for fields that do not use field options
    #
    # @return [Array] An array of field record values
    def collect_field_records_by_fsa_and_fsc(fsa, fsc)
      # I think this needs to return some sort of hash
      records = DynamicFieldsets::FieldRecord.where(:fieldset_associator_id => fsa.id, :fieldset_child_id => fsc.id)
      return records.collect { |r| { :value => r.value } }
    end

    # Updates the field records for the field based on the given values
    #
    # This must be overridden if it is used
    #
    # @param [DynamicFieldsets::FieldsetAssociator] fsa The associator the value is attached to
    # @param [DynamicFieldsets::FieldsetChild] fieldset_child The fieldset child for the value
    # @param [Array or String] value The new values inputted by the user from the form
    def update_field_records(fsa, fieldset_child, value)
      throw "Field.update_field_records must be overridden to save data from the form."
    end
  end
end
