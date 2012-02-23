module DynamicFieldsets
  # Creates datetime tags on a form
  #
  # The datetime tag currently defaults to the current time if nothing is set with the year range starting 70 years in the past
  #
  # The value of the input is stored as a string so costly Time.parse calls are used to parse the string
  # This may have to be changed in the future
  class DatetimeField < Field
    acts_as_field_with_single_answer

    # Returns the current value if set, then the default value if set, then the current time as a Time object
    #
    # @return [Time] The current time stored in the datetime field
    def get_datetime_or_today(value)
      default_time = value_or_default_for_form(value)
      if default_time.empty?
        return Time.now
      else
        return Time.parse(default_time)
      end
    end

    # Includes information used in the date_options argument (third) on the date select helper
    #
    # @return [Hash] Data for the datetime form partial
    def form_partial_locals(args)
      output = super
      output[:date_options] = { 
        :start_year => Time.now.year - 70,
        :default => get_datetime_or_today(args[:value])
      }
      return output
    end
  end
end

