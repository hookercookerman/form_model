# encoding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe "ProductForm" do
  let(:product) do
    FactoryGirl.build :product
  end
  subject{ProductForm.load(product)}
  before {product.stub(:persisted? => false)}

  it "should delegate persisted?" do
    product.should_receive(:persisted?)
    subject.persisted?
  end

  describe "when loading from a new product" do
    let(:product) do
      FactoryGirl.build :product
    end
    subject{ProductForm.load(product)}
    before{subject.stub(data_model_attribute_names: [:price])}
    its(:name){should be_nil}
    its(:title){should be_nil}
    its(:description){should be_nil}
    its(:valid?){should be_false}
  end

  describe "when loading form with incorrect model type" do
    let(:user) {FactoryGirl.build(:user)}
    it "should raise Exception" do
      expect{ProductForm.load(user)}.to raise_error(FormModel::ModelMisMatchError)
    end
  end

  describe "when loading from a product with given attributes" do
    let(:product) do
      FactoryGirl.build :product, title: "testing title", description: "testing description", price: {cents: 10}
    end
    subject{ProductForm.load(product)}
    before{subject.stub(data_model_attribute_names: [:price])}
    its(:title){should eq("testing title")}
    its(:name){should be_nil}
    its(:description){should eq("testing description")}
    its(:valid?){should be_true}
  end

  describe "validation" do
    let(:product) do
      FactoryGirl.build :product, title: "testing title", description: "testing description"
    end
    subject{ProductForm.load(product)}
    before {subject.stub(data_model_attribute_names: [:price])}

    it "should not be valid as the data model is not valid" do
      product.stub(valid?: false, errors: {price: "not valid"})
      subject.should_not be_valid
    end

    it "should not be valid as price is not valid" do
      product.stub(valid?: true)
      subject.should_not be_valid
    end
  end

  describe "save" do
    let(:product) do
      FactoryGirl.build :product, title: "testing title", description: "testing description", price: {cents: 10}
    end
    subject{ProductForm.load(product)}
    before do 
      subject.stub(data_model_attribute_names: [:title])
      product.stub(save: true)
    end

    it "should write_attributes to the model" do
      product.should_receive(:write_attributes)
      subject.save
    end

    it "should save to the model" do
      product.should_receive(:write_attributes)
      subject.save
    end

    it "should check validation" do
      subject.should_receive(:save)
      subject.save
    end
  end

  describe "when mapping a price of 50 GBP to the form model" do
    let(:product) {FactoryGirl.build(:product, price: {"currency" => "GBP", cents: 50})}
    subject{ProductForm.load(product)}
    its(:price){should eq(VMoney.new(currency: "GBP", cents: 50))}
  end

  describe "when setting money via amount" do
    let(:product) {FactoryGirl.build(:product, price: {"currency" => "GBP", cents: 50})}

    before do
      @form = ProductForm.load(product)
      @form.stub(data_model_attribute_names: [:price])
      @form.update(price: {"amount" => "20.0"})
      @form.update_data_model!
    end

    it "should set a price hash on the product" do
      product.price["cents"].should eq(2000)
    end
  end

  describe "when mapping a vmoney price from the form to the model" do
    let(:product) {FactoryGirl.build(:product, price: {"currency" => "GBP", cents: 50})}
    before do
      @form = ProductForm.load(product)
      @form.stub(data_model_attribute_names: [:price])
      @form.price = {"currency"  => "EUR"}
      @form.update_data_model!
    end
    it "should set a price hash on the product" do
      product.price["currency"].should eq("EUR")
    end
  end

  describe "when mapping a start_time with of now" do
    let(:now){Time.now}
    let(:split_time){now.strftime("%R").split(?:)}
    let(:product) {FactoryGirl.build(:product, start_at: now)}
    subject{ProductForm.load(product)}
    its(:start_at_date){ should eq(now.to_date.to_s)}
    its(:start_at_hr) {  should eq(split_time.first)}
    its(:start_at_min) { should eq(split_time.last)}
  end
end
