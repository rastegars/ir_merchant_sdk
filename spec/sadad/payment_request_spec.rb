require 'spec_helper'
require 'ir_merchant_sdk/gateways/sadad/payment_request'

RSpec.describe Sadad::PaymentRequest, :type => :model do
  subject do 
    Sadad::PaymentRequest.new({
      key: 'X' * 32,
      terminal_id: '12345678',
      merchant_id: '3243423432',
      order_id: 4,
      amount: 5000,
      return_url: 'www.example.com',
      percentage: 50,
      iban_number: "AD.434324.3"
    })
  end

  describe "#call" do
    it "returns a token" do
      allow(subject).to receive_messages(call: { 'Token' => 'abcd', 'ResCode' => '0' })
      response = subject.call
      expect(response['ResCode']).to eq('0')
      expect(response).to have_key('Token')
    end
  end
end