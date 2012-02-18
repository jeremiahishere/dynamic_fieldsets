module DynamicFieldsets
  class DateField < Field
    acts_as_field_with_one_answer
    
    # test to make sure sti is working
    def date_specific_method
      puts "in the datefield class"
    end
  end
end

