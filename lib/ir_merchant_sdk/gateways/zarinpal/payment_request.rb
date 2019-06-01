# frozen_string_literal: true

require 'savon'

module Zarinpal
  class PaymentRequest
    class ZarinpalError < StandardError; end

    attr_reader :merchant_id, :amount, :callback_url, :description, :additional_data

    def initialize(options = {})
      @merchant_id = options[:merchant_id]
      @amount = options[:amount]
      @callback_url = options[:callback_url]
      @description = options[:description]
      @additional_data = options[:additional_data]
    end

    def conn
      wsdl_address = 'https://sandbox.zarinpal.com/pg/services/WebGate/wsdl'
      Savon.client(wsdl: wsdl_address)
    end

    def call
      response = conn.call(:payment_request_with_extra, message: payload)
      results = response.body
      status = results[:payment_request_with_extra_response][:status]

      raise(ZarinpalError) if status.to_i < 100

      results[:payment_request_with_extra_response]
    end

    def payload
      {
        'MerchantID' => merchant_id,
        'Amount' => amount,
        'Description' => description,
        'CallbackURL' => callback_url,
        'AdditionalData' => ''
      }
    end
  end
end
