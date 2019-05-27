require 'date'
require 'openssl'
require 'base64'
require 'httparty'

module Sadad
  class PaymentRequest
    attr_reader :key, :terminal_id, :merchant_id, :order_id, :amount, :return_url, :percentage, :iban_number

    def initialize(options = {})
      @key = options[:key]
      @terminal_id = options[:terminal_id]
      @merchant_id = options[:merchant_id]
      @order_id = options[:order_id]
      @amount = options[:amount]
      @percentage = options[:percentage]
      @iban_number = options[:iban_number]
      @return_url = options[:return_url]
    end

    def call
      request_url = 'https://sadad.shaparak.ir/VPG/api/v0/Request/PaymentRequest'
      response = HTTParty.post(request_url, :body => payload, format: :json)
      response.parsed_response
    end

    def payload
      data = "#{terminal_id};#{order_id};#{amount}"
      request_body = {
        'MerchantId' => merchant_id,
        'TerminalId' => terminal_id,
        'Amount' => amount,
        'OrderId' => order_id,
        'LocalDateTime' => DateTime.now,
        'ReturnUrl' => return_url,
        'SignData' => encrypt_pkcs7(key, data)
      }
      if iban_number && !iban_number.empty? && (company_share > 0)
        request_body.merge({
          'MultiplexingData' => {
            'Type' => "Percentage",
            'MultiplexingRows' => [
              'IbanNumber' => iban_number,
              'Percentage' => percentage
            ]
          }
        })
      end
      request_body
    end

    private
      # This method will be moved to a seperate module
      def encrypt_pkcs7(key, str)
        cipher = OpenSSL::Cipher::DES.new("EDE3")
        cipher.encrypt
        cipher.key = Base64.decode64(key)
        cipher_text = cipher.update(str) + cipher.final
        Base64.strict_encode64(cipher_text)
      end  
  end
end
