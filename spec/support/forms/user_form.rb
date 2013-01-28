class UserForm
  include FormModel
  bind_to{User}

  attribute :id, String
  attribute :email, String
  attribute :name, String

  # Mappers
  mapper DevEmailMapper, form: {email: :email}
end
