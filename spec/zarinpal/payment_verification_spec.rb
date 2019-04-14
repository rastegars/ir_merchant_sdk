require 'spec_helper'
require './lib/gateways/zarinpal/payment_verification'

describe Zarinpal::PaymentVerification, :type => :model do
  subject do 
    Zarinpal::PaymentVerification.new({
      merchant_id: '12345678',
      amount: '12345678',
      authority: 'authority'
    })
  end

  describe "#call" do
    it "is successfull" do
      allow(subject).to receive_messages(call: { payment_verification_with_extra_response: { status: 100 }})
      response = subject.call
      expect(response[:payment_verification_with_extra_response][:status]).to eq(100)
    end
  end
end