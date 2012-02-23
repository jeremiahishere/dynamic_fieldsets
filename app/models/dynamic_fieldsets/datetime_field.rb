module DynamicFieldsets
  class DatetimeField < Field
    acts_as_field_with_one_answer

    def get_datetime_or_today(value)
      default_time = value_or_default_for_form(value)
      if default_time.empty?
        return Time.now
      else
        return Time.parse(default_date)
      end
    end

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

