# encoding: utf-8
require File.expand_path("../spec_helper", __FILE__)

describe "FormMode::Mappers" do
  context "new mapper" do
    let(:new_mapper) do
      Class.new do
        include FormModel::Mapper
      end
    end

    it "should be able to set form keys" do
      new_mapper.should respond_to(:form_keys) 
    end    

    it "should be able to set form keys" do
      new_mapper.should respond_to(:model_keys) 
    end
  end

  context "mapper instance with set keys" do
    let(:new_mapper) do
      Class.new do
        include FormModel::Mapper
        form_keys :price
        model_keys :price
      end
    end
    let(:options){{form: {price: :price}}}
    let(:form){double(:price => "form_price")}
    let(:model){double(:price => "model_price")}

    subject{new_mapper.new(options)}

    it "should have a form attribute price" do
      subject.form_attribute(:price).should eq("price")
    end

    it "should have a model attribute price" do
      subject.form_attribute(:price).should eq("price")
    end

    it "should be able to the form value" do
      subject.form_value(form, :price).should eq("form_price")
    end

    it "should be able to the model value" do
      subject.model_value(model, :price).should eq("model_price")
    end

    describe "#asset_form_values" do
      it "should return a filled hash with values are not nil" do
        subject.assert_form_values(form, :price) do |values|
          values.should eq({:price => "form_price"})
        end
      end

      it "should return empty hash if one of the values is nil" do
        subject.assert_form_values(form, :price, :beans) do |values|
          values.should eq({:price => "form_price"})
        end.should eq({})
      end
    end

    describe "#asset_model_values" do
      it "should return a filled hash with values are not nil" do
        subject.assert_model_values(model, :price) do |values|
          values.should eq({:price => "model_price"})
        end
      end

      it "should return empty hash if one of the values is nil" do
        subject.assert_model_values(model, :price, :beans) do |values|
          values.should eq({:price => "model_price"})
        end.should eq({})
      end
    end

  end
end
