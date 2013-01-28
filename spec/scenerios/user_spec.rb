# encoding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe "User" do
  let(:user) {FactoryGirl.build(:user)}
  subject{UserForm.load(user)}
  before do
    subject.stub(data_model_attribute_names: [:email])
    subject.email = "hookercookerman@gmail.com"
    subject.update_data_model!
  end

  it "should map a real email to a dev email" do
    user.email.should eq("hookercookerman$gmail.com")
  end
end
