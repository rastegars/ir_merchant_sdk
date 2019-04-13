require 'savon'

module Zarinpal
  class PaymentRequest
    class ZarinPalError < StandardError; end

    attr_reader :merchant_id, :amount, :callback_url, :description, :additional_data

    def initialize(options = {})
      @merchant_id = options[:merchant_id]
      @amount = options[:amount]
      @callback_url = options[:callback_url]
      @description = options[:description]
      @additional_data = options[:additional_data]
    end

    def call
      wsdl_address = 'https://sandbox.zarinpal.com/pg/services/WebGate/wsdl'
      message = {
        'MerchantID' => merchant_id,
        'Amount' => amount,
        'Description' => description,
        'CallbackURL' => verify_url,
      }

      response = Savon.client(wsdl: wsdl_address).call(:payment_request_with_extra, message: message)
      results = response.body
      status = results[:payment_request_with_extra_response][:status]

      raise(ZarinPalError) if status.to_i < 100 || !valid?

      results[:payment_request_with_extra_response]
    end
  end
end
