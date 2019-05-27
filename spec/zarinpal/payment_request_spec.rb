require 'spec_helper'
require 'ir_merchant_sdk/gateways/zarinpal/payment_request'

RSpec.describe Zarinpal::PaymentRequest, :type => :model do
  subject do 
    Zarinpal::PaymentRequest.new({
      merchant_id: '12345678',
      amount: 5000,
      callback_url: 'www.example.com',
      description: 'Some descriptions',
    })
  end

  describe "#call" do
    it "returns a token" do
      allow(subject).to receive_messages(call: { merchant_id: 'X' * 36, authority: 'abcd', amount: 5000 })
      response = subject.call
      expect(response).to have_key(:authority)
    end
  end
end