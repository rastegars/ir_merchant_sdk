require 'spec_helper'
require './lib/zarinpal_gateway'

describe ZarinpalGateway, :type => :model do
  subject do 
    ZarinpalGateway.new({
      merchant_id: '3243423432',
      amount: 5000,
      verify_url: 'fake/url',
      company_share: 50,
      gateway_account_no: 'AD.434324.3',
      description: 'Descript Text',
      wages_description: 'Wages Descript Text'
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
end