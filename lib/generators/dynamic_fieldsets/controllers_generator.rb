require 'rails/generators'

module DynamicFieldsets 
  module Generators
    # Generator for copying the controllers into the project
    #
    # @author Jeremiah Hemphill
    class ControllersGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app/controllers/dynamic_fieldsets/', __FILE__)

      desc <<DESC
Description:
  Copies over controllers for the multipart form system.
DESC

      desc''
      def copy_or_fetch #:nodoc:
        return copy_all_controllers
      end

      private

      def copy_all_controllers
        filename_pattern = File.join self.class.source_root, "*.rb"
        Dir.glob(filename_pattern).map { |f| File.basename f}.each do |f|
          copy_file f, "app/controllers/dynamic_fieldsets/#{f}"
        end
      end
    end
  end
end
