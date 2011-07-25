module DynamicFieldsets
  module DynamicFieldsetsInModel
    def self.include(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_dynamic_fieldset(*args)
        mattr_accessor :dynamic_fieldsets unless self.respond_to?(:dynamic_fieldsets)
        args.each do |arg|
          self.dynamic_fieldsets[arg[:name]] = arg
        end

        include DynamicFieldsets::DynamicFieldsetsInModel::InstanceMethods
      end
    end

    module InstanceMethods

      def method_missing(sym, *args)
        super(sym, *args)
        # if matches a form_name
        #   get the form associator
        # if matchs form_name_fieldset
        #   get the fieldset
        # call super
      end

      def respond_to?(sym, *args)
        # if it matches form_name or form_name_fieldset
        #   return true
        # call super
        super(sym, *args)
      end

      # method matches fingerprint_form
      # want the fieldset associator object for that specified fieldset associator
      def match_fieldset_associator?(sym, args)
      end

      # method matches fingerprint_form_fieldset
      # want the fieldset object for that specified fieldset associator
      def match_fieldset?(sym, args)
      end

      # returns the fieldset associator object for the named fieldset assocation
      def fieldset_associator(sym)
      end

      # returns the fieldset object for the specified named fieldset association
      def fieldset(sym)
      end

    end
  end
end
