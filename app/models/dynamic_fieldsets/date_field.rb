module DynamicFieldsets
  class DateField < Field
    acts_as_field_with_one_answer

    # gets the given date if it exists, default if it exists, or today if everything else failse
    def get_date_or_today(value)
      default_date = value_or_default_for_form(value)
      if default_date.empty?
        return Date.today
      else
        return Date.parse(default_date)
      end
    end

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

