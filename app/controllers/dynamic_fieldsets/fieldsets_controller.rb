module DynamicFieldsets
  # Basic controller for managing fieldsets
  class FieldsetsController < ApplicationController
    unloadable
  
    # Show all fieldsets
    def index
      @fieldsets = DynamicFieldsets::Fieldset.all

      respond_to do |format|
        format.html
      end
    end
    
    # Show all root fieldsets
    def roots
      @fieldsets = DynamicFieldsets::Fieldset.roots

      respond_to do |format|
        format.html { render action: 'index' }
      end
    end
    
    # Show single fieldset
    def show
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])

      respond_to do |format|
        format.html
      end
    end 

    # Create new fieldset
    def new
      @fieldset = DynamicFieldsets::Fieldset.new()

      respond_to do |format|
        format.html
      end
    end
    
    # Edit existing record
    def edit
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])

      respond_to do |format|
        format.html
      end
    end

    # Show a record and all children
    def children
      @fieldset_child = DynamicFieldsets::FieldsetChild.find_by_id params[:id]

      respond_to do |format|
        format.html
      end
    end
    
    # ...
    def reorder
      root = params[:id]
      parent_child_pairs = params[:child].inject({}) do |hash,(key,val)|
        if val.eql? 'root' then hash[key.to_i] = root.to_i
        else hash[key.to_i] = val.to_i
        end
        hash
      end
      
      @order = {}
      parent_child_pairs.each do |key,val|
        if @order.keys.include? val then @order[val].push key
        else @order.merge! val=>[key]
        end
      end
      
      # { 4 => [3,7,6], 5 => [8,9] }
      @order.each do |parent_id,children|
        children.each_with_index do |child_id,index|
          old_child = DynamicFieldsets::FieldsetChild.find_by_child_id child_id
          child_type = old_child.child_type
          old_child.destroy
          fieldset_child = DynamicFieldsets::FieldsetChild.new
          fieldset_child.fieldset_id = parent_id
          fieldset_child.child_id = child_id
          fieldset_child.child_type = child_type
          fieldset_child.order_num = index+1
          fieldset_child.save
        end
      end

      respond_to do |format|
        format.json { render :json => @order }
      end
    end
    
    # Save new record
    def create
      parent_id = params[:parent]
      @fieldset = DynamicFieldsets::Fieldset.new(params[:dynamic_fieldsets_fieldset])

      respond_to do |format|
        if @fieldset.save
          if !parent_id.empty?
            parent = DynamicFieldsets::Fieldset.find_by_id(parent_id)
            DynamicFieldsets::FieldsetChild.create( :fieldset => parent, :child => @fieldset )
            #relation = @fieldset.fieldset_children.build( :fieldset => parent )
            #relation.child = @fieldset
            #relation.save
          end
          format.html { redirect_to( dynamic_fieldsets_fieldset_path(@fieldset), :notice => "Successfully created a new fieldset" )}
        else
          format.html { render :action => "new" }
        end
      end
    end

    # Update existing record
    def update
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])

      respond_to do |format|
        if @fieldset.update_attributes(params[:dynamic_fieldsets_fieldset])
          format.html { redirect_to( dynamic_fieldsets_fieldset_path(@fieldset), :notice => "Successfully updated a fieldset" )}
        else
          format.html { render :action => "edit" }
        end
      end
    end

    # Destroy existing record
    def destroy
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])
      @fieldset.destroy

      respond_to do |format|
        format.html { redirect_to( dynamic_fieldsets_fieldsets_path, :notice => "Fieldset deleted successfully!" )}
      end
    end

  end
end
