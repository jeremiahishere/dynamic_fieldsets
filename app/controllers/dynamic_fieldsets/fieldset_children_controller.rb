module DynamicFieldsets
  # ...
  class FieldsetChildrenController < ApplicationController
    unloadable
    
    # ...
    def index

      respond_to do |format|
        format.html
      end
    end
    
  end
end