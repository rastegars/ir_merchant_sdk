require 'date'
require 'openssl'
require 'base64'
require 'httparty'

module Sadad
  class PaymentVerification
    attr_reader :key, :token

    def initialize(options = {})
      @key = options[:key]
      @authority = options[:token]
    end

    def call
      verification_url = 'https://sadad.shaparak.ir/vpg/api/v0/Advice/Verify'
      request_body = { 'Token' => token, 'SignData' => encrypt_pkcs7(key, token) }
      HTTParty.post(verification_url, :body => request_body, format: :json).parsed_response
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
