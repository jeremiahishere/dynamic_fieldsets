module DynamicFieldsets
  # Creates date tags on a form
  #
  # The date tag currently defaults to the current date if nothing is set with the year range starting 70 years in the past
  #
  # The value of the input is stored as a string so costly Date.parse calls are used to parse the string
  # This may have to be changed in the future
  class DateField < Field
    acts_as_field_with_single_answer

    # Returns the current value if set, then the default value if set, then the current date as a Date object
    #
    # @return [Date] The current time stored in the date field
    def get_date_or_today(value)
      default_date = value_or_default_for_form(value)
      if default_date.empty?
        return Date.today
      else
        return Date.parse(default_date)
      end
    end

    # Includes information used in the date_options argument (third) on the date select helper
    #
    # @return [Hash] Data for the date form partial
    def form_partial_locals(args)
      output = super
      output[:date_options] = { 
        :start_year => Time.now.year - 70,
        :default => get_date_or_today(args[:value])
      }
      return output
    end
  end
end

