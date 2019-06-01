# frozen_string_literal: true

require 'spec_helper'
require 'ir_merchant_sdk/gateways/sadad/payment_verification'

RSpec.describe Sadad::PaymentVerification, type: :model do
  subject do
    Sadad::PaymentVerification.new(
      key: 'X' * 32,
      token: '12345678'
    )
  end

  describe '#call' do
    it 'is successfull' do
      request_url = 'https://sadad.shaparak.ir/vpg/api/v0/Advice/Verify'
      stub_request(:post, request_url).to_return(status: 200, body: { ResCode: '0' }.to_json)
      response = subject.call
      expect(response['ResCode']).to eq('0')
    end
  end
end
