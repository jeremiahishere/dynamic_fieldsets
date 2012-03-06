# Controller for the FieldsetAssociator model
# Allows users to view but not create or edit fieldset associators
module DynamicFieldsets
  class FieldsetAssociatorsController < ApplicationController

    # show all fieldset associators
    def index
      @fieldset_associators = DynamicFieldsets::FieldsetAssociator.all

      respond_to do |format|
        format.html
      end
    end

    # show one fieldset associator
    def show
      @fieldset_associator = DynamicFieldsets::FieldsetAssociator.find_by_id(params[:id])
      respond_to do |format|
        format.html
      end
    end
  end
end
