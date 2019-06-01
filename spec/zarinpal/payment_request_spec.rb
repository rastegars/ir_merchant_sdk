require 'spec_helper'
require 'ir_merchant_sdk/gateways/zarinpal/payment_request'
require "savon/mock/spec_helper"

RSpec.describe Zarinpal::PaymentRequest, :type => :model do

  include Savon::SpecHelper

  before(:all) do 
    WebMock.disable!
    savon.mock!
  end

  after(:all) do
    WebMock.enable!
    savon.unmock!
  end

  merchant_id = '12345678'
  amount = 5000
  callback_url = 'www.example.com'
  description = 'Some descriptions'

  subject do 
    Zarinpal::PaymentRequest.new({
      merchant_id: merchant_id,
      amount: amount,
      callback_url: callback_url,
      description: description,
    })
  end

  describe "#call" do
    it "returns a token" do


      message = {
        'MerchantID' => merchant_id,
        'Amount' => amount,
        'Description' => description,
        'CallbackURL' => callback_url,
        'AdditionalData' => ''
      }

      file_path = File.expand_path('./payment_request_response.xml', File.dirname(__FILE__))
      file = File.open(file_path, "rb")
      data = file.read

      savon.expects(:payment_request_with_extra).with(message: :any).returns(data)

      response = subject.call
      expect(response).to have_key(:authority)
    end
  end
end