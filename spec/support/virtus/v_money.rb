class VMoney
  include Virtus::ValueObject
  include ActiveModel::Validations
  
  # attributes
  attribute :cents, Integer, default: 0
  attribute :currency, String

  def amount
    sprintf "%0.02f", (BigDecimal(cents) / BigDecimal("100"))
  end

  def amount=(value)
    self.cents = (BigDecimal(value) * BigDecimal("100")).to_i
  end

  validates :cents, presence: true, :numericality => { :only_integer => true, greater_than: 0 }
end
