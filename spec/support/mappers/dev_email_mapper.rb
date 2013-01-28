class DevEmailMapper
  include FormModel::Mapper
  form_keys  :email
  model_keys :email

  def to_form(model)
    assert_model_values(model, :email) do |values|
      {form_attribute(:email) => values[:email].gsub("$", "@")}
    end
  end

  def to_model(form)
    assert_form_values(form, :email) do |values|
      {model_attribute(:email) => values[:email].gsub("@", "$")}
    end
  end
end
