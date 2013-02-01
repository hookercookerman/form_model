class Product
  attr_accessor :id, :price, :title, :name, :description, :start_at

  def price
    @price ||= {}
  end

  def attributes
    {"id" => id, "price" => price, "description" => description, "title" => title, start_at: start_at}
  end

  def write_attributes(attributes)
    attributes.each do |attr, value|
      self.send("#{attr}=", value)
    end
  end

  def valid?(context = nil)
    true
  end

  def errors
    {}
  end

end
