class MoneyMapper
  include FormModel::Mapper
  form_keys  :price
  model_keys :price

  def to_form(model)
    assert_model_values(model, :price) do |values|
      {form_attribute(:price) => VMoney.new(values[:price])}
    end
  end

  def to_model(form)
    assert_form_values(form, :price) do |values|
      {model_attribute(:price) => values[:price].to_hash.stringify_keys}
    end
  end
end
