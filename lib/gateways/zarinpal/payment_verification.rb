require 'savon'

module Zarinpal
  class PaymentVerification
    class ZarinpalVerificationError < StandardError; end

    attr_reader :merchant_id, :amount, :authority

    def initialize(options = {})
      @merchant_id = merchant_id
      @amount = amount
      @authority = authority
    end

    def conn
      wsdl_address = 'https://sandbox.zarinpal.com/pg/services/WebGate/wsdl'
      Savon.client(wsdl: wsdl_address)
    end

    def call
      response = conn.call(:payment_verification_with_extra, message: payload)
      results = response.body
      status = results[:payment_request_with_extra_response][:status]

      raise(ZarinpalVerificationError) if status.to_i < 100

      results
    end

    def payload
      {
        'MerchantID' => merchant_id,
        'Amount' => amount,
        'Authority' => authority,
      }
    end
  end
end
