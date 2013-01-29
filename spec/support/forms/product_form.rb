class ProductForm
  include FormModel
  bind_to{Product}

  # Attributes
  attribute :name, String
  attribute :title, String
  attribute :description, String
  attribute :price, VMoney
  attribute :selected_price, VMoney

  attribute :start_at_date, String
  attribute :start_at_hr,   String
  attribute :start_at_min,  String
  
  # Mappers
  mapper MoneyMapper, form: {price: :price}
  mapper DateHourMinMapper,  
    form: {date: :start_at_date, hour: :start_at_hr, min: :start_at_min}, 
    model: {time: :start_at}

  # Validations
  validates :title, presence: true
  validates_associated :price
end
