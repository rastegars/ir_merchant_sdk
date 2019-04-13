require 'spec_helper'
require './lib/sadad_gateway'

describe SadadGateway, :type => :model do
  subject do 
    SadadGateway.new({
      key: 'X' * 32,
      terminal_id: '12345678',
      merchant_id: '3243423432',
      order_id: 4,
      amount: 5000,
      verify_url: 'fake/url',
      company_share: 50,
      gateway_account_no: "AD.434324.3"
    })
  end

  describe "#request_token" do
    it "returns a token" do
      allow(subject).to receive_messages(call_token_request: { 'Token' => 'abcd', 'ResCode' => '0' })
      response = subject.request_token
      expect(response['ResCode']).to eq('0')
      expect(response).to have_key('Token')
    end
  end

  describe "#verify" do
    it "is successfull" do
      allow(subject).to receive_messages(call_token_request: { 'Token' => 'abcd', 'ResCode' => '0' })
      allow(subject).to receive_messages(verify: { 'ResCode' => '0' })
      token = subject.request_token['Token']
      response = subject.verify(token)
      expect(response['ResCode']).to eq('0')
    end
  end
end