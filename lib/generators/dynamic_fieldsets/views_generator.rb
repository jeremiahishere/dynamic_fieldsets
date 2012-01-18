require 'rails/generators'

module DynamicFieldsets 
  module Generators
    # Generator for copying the views into the project
    #
    # @author Jeremiah Hemphill
    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app/views/dynamic_fieldsets/', __FILE__)

      desc <<DESC
Description:
  Copies over controller and views for the multipart form system.
DESC

      desc''
      def copy_or_fetch#:nodoc:
        view_directory :fields
        view_directory :fieldset_associators
        view_directory :fieldset_children
        view_directory :fieldsets
        view_directory :shared
      end

      private

      # copy an indivindual directory to the target project
      # @param [Symbol] name Name of the directory
      # @param [String] _target_path Location of the directory
      def view_directory(name, _target_path = nil)
        directory name.to_s, _target_path || "#{target_path}/#{name}"
      end

      # base path to put the copied views into
      def target_path
        "app/views/dynamic_fieldsets"
      end
    end
  end
end

