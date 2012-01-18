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
        puts "hello"
        view_directory :fields
        view_directory :fieldset_associators
        view_directory :fieldset_children
        view_directory :fieldsets
        view_directory :shared
      end

      private

      def view_directory(name, _target_path = nil)
        directory name.to_s, _target_path || "#{target_path}/#{name}"
      end

      def target_path
        "app/views/dynamic_fieldsets"
      end

      def copy_default_views
        puts "world"
        controllers = ["fields", "fieldset_associators", "fieldset_children", "fieldsets", "shared"]
        controllers.each do |c|
          copy_views(c)
        end
      end

      def copy_views(controller)
        filename_pattern = File.join(File.expand_path('../../../../app/views/dynamic_fieldsets/', __FILE__), "/#{controller}/*.html.erb")
        Dir.glob(filename_pattern).map { |f| File.basename f}.each do |f|
          copy_file f, "app/views/dynamic_fieldsets/#{controller}/#{f}"
        end
      end
    end
  end
end

