# Helper for the dependency group model to create valid attributes
module DependencyGroupHelper 
  def valid_attributes
    {
      :fieldset_child_id => 42,
      :action => "show",
    }
  end
end
