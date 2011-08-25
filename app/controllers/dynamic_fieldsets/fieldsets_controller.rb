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
      @fieldset = DynamicFieldsets::Fieldset.find_by_id params[:id]

      respond_to do |format|
        format.html
      end
    end

    # associates a field or fieldset with the given fieldset by creating a fieldset child
    def associate_child
      @fieldset = DynamicFieldsets::Fieldset.find_by_id(params[:id])
      @field = DynamicFieldsets::Field.find_by_id(params[:field])

      @fieldset_child = DynamicFieldsets::FieldsetChild.where(:child_id => @field.id, :child_type => @field.class.name, :fieldset_id => @fieldset.id).first
      if(@fieldset_child.nil?)
        @fieldset_child = DynamicFieldsets::FieldsetChild.new(
          :child_id => @field.id, 
          :child_type => @field.class.name,
          :fieldset_id => @fieldset.id,
          :order_num => DynamicFieldsets::FieldsetChild.where(:fieldset_id => @fieldset.id).count + 1)
      else
        child_already_exists = true
      end

      respond_to do |format|
        if @fieldset_child.save
          if child_already_exists
            notice_text = "Field was already associated with the fieldset"
          else
            notice_text = "Successfully associated a field"
          end
          format.html { redirect_to(dynamic_fieldsets_children_dynamic_fieldsets_fieldset_path(@fieldset), :notice => notice_text )}
        else
          format.html { redirect_to(dynamic_fieldsets_children_dynamic_fieldsets_fieldset_path(@fieldset), :notice => "Field was not successsfully associated." )}
        end
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
        if @order.keys.include? val
        then @order[val].push key
        else @order.merge! val=>[key]
        end
      end
      
      # e.g. { 1 => [6], 6 => [7,8] }
      # First number is always the root Fieldset id.
      # The rest are FieldsetChild ids.
      @order.each do |parent_identifier,children|
        if parent_identifier.eql? @order.first[0] # This is the first number:
        then parent_id = parent_identifier # the root fieldset id.
        # Otherwise, we need to retrieve the parent fieldset_id from the FieldsetChild's child_id.
        else parent_id = DynamicFieldsets::FieldsetChild.find_by_id(parent_identifier).child_id
        end
        children.each_with_index do |fieldset_child_id,index|
          fieldset_child = DynamicFieldsets::FieldsetChild.find_by_id fieldset_child_id
          fieldset_child.fieldset_id = parent_id
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
