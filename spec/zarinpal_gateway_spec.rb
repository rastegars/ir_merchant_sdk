require 'spec_helper'
require './lib/zarinpal_gateway'

describe ZarinpalGateway, :type => :model do
  subject do 
    ZarinpalGateway.new({
      merchant_id: 'X' * 36,
      amount: 5000,
      verify_url: 'fake/url',
      company_share: 50,
      gateway_account_no: 'AD.434324.3',
      description: 'Descript Text',
      wages_description: 'Wages Descript Text'
    })
  end

  describe "#call" do
    it "returns a hash" do
      allow(subject).to receive_messages(call: { merchant_id: 'X' * 36, authority: 'abcd', amount: 5000 })
      response = subject.call
      expect(response).to have_key(:authority)
    end
  end
end