class DateHourMinMapper
  include FormModel::Mapper

  form_keys :date, :hour, :min
  model_keys :time
  
  def to_form(model)
    assert_model_values(model, :time) do |values|
      time = values[:time]
      split_time = split_time(time)
      {
        form_attribute(:date) => time.to_date.to_s,
        form_attribute(:hour) => split_time.first,
        form_attribute(:min) => split_time.last
      }
    end
  end

  def to_model(form)
    assert_form_values(form, :date, :hour, :min) do |values|
      {model_attribute(:time) => time_from_form(values)}
    end
  end

  private
  def split_time(time)
    time.strftime("%R").split(?:)
  end

  def time_from_form(values)
    time = Date.parse(values[:date]).to_time
    time.change(:hour => values[:hour], min: values[:min])
  end

end
