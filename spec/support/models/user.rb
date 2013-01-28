class User
  attr_accessor :id, :name, :email

  def attributes
    {"id" => id, "name" => name, "email" => email}
  end

  def write_attributes(attributes)
    attributes.each do |attr, value|
      self.send("#{attr}=", value)
    end
  end

  def valid?
    true
  end

  def errors
    {}
  end

end
