# FormModel

Idea is to have an easy way to create form objects; 

Inspiration
[http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/](Code Climate Extract From Objects)

What are form objects

1. They can validate your form inputs; (leaving your model to validate
   domain validations)

2. hide access to the model; only form attributes are allowed to be
   updated (mass assignment anyone) 

3. have a single place to show any transformation that the form needs to
   represent from the model; Example Price Hashes; Time Strings;
   locations and value objects 

4. Essentially you now have 1 place to do any form stuff

At present this is tied to mongoid; if you want other support I accept
pull requests :)


## Installation

Add this line to your application's Gemfile:

    gem 'form_model'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install form_model

## Usage

Typical flow In Rails App

have a forms directory; 

Create a Form that binds to a partical model class;
Define what attributes you want the form to have;

```ruby
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
```

# Creating a Form Object

```ruby
  product_form = ProductForm.new
```

As the product form is bound to a product class a new product will be
associated with this form.

# Loading a Form from the model (typical Approach)

```ruby
  product = Product.find(params[:id])
  product_form = ProductForm.load(product)
```

This will map the model attributes on to the form model; applying any
specific mappers that have been created for the form object

# Saving A Form

A form *save* method will use both validations on the form
model and the model to determine if its valid and a save will also call
a models save method; 

```ruby
  product_form = ProductForm.load(product).update(params[:product])
  if product_form.save
    # do stuff
  else
    # do other stuff
  end
```

# Updating model Explicity

```ruby
  product_form = ProductForm.new
  product_form.update(params[:product])
  product_form.update_data_model!
```

updating a form with a hash will only update the form; if you wish to
set the attributes on the model you will need to call update_data_model!
*NOTE* this will not save the model

# Mappers

if you need to transform data in and out of forms and models you can
create mappers; as shown in the productForm example; look at the
spec/support mappers for examples

```ruby
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
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
