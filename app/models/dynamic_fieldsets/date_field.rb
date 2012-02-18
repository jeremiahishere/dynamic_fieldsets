module DynamicFieldsets
  class DateField < Field
    
    # test to make sure sti is working
    def date_specific_method
      puts "in the datefield class"
    end
  end
end

