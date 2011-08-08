# Helper for the field model to create valid attributes
module DependencyHelper
  # this has issues with not being able to set type
  # I am manually setting it where it is needed to avoid problems
  def valid_attributes
    {
      :fieldset_child_id => 100,
      :relationship => "equals",
      :value => "test string",
      :dependency_clause_id => 100
    }
  end
end
