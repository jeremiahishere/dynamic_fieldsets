module DynamicFieldsets
  class DatetimeField < Field
    acts_as_field_with_one_answer

    def form_partial_locals(args)
      output = super
      output[:date_options] = { 
        :start_year => Time.now.year - 70,
        :default => Time.parse(value_or_default_for_form(args[:value])) }
      output[:attrs][:
    end
  end
end

