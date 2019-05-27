require 'spec_helper'
require 'ir_merchant_sdk/gateways/sadad/payment_verification'

RSpec.describe Sadad::PaymentVerification, :type => :model do
  subject do 
    Sadad::PaymentVerification.new({
      key: 'X' * 32,
      token: '12345678',
    })
  end

  describe "#call" do
    it "is successfull" do
      allow(subject).to receive_messages(call: { 'ResCode' => '0' })
      response = subject.call
      expect(response['ResCode']).to eq('0')
    end
  end
end