require 'date'
require 'openssl'
require 'base64'
require 'httparty'

class SadadGateway
  attr_reader :key, :terminal_id, :merchant_id, :order_id, :amount, :verify_url, :company_share, :gateway_account_no

  def initialize(options = {})
    @key = options[:key]
    @terminal_id = options[:terminal_id]
    @merchant_id = options[:merchant_id]
    @order_id = options[:order_id]
    @amount = options[:amount]
    @company_share = options[:company_share]
    @gateway_account_no = options[:gateway_account_no]
    @verify_url = options[:verify_url]
  end

  def request_token
    data = "#{terminal_id};#{order_id};#{amount}"
    call_token_request(data)
  end

  def verify(authority)
    request_body = { 'Token' => authority, 'SignData' => encrypt_pkcs7(ENV['sadad_key'], authority) }
    HTTParty.post(ENV['sadad_request_url'], :body => request_body, format: :json).parsed_response
  end

  private
    def encrypt_pkcs7(key, str)
      cipher = OpenSSL::Cipher::DES.new("EDE3")
      cipher.encrypt
      cipher.key = Base64.decode64(key)
      cipher_text = cipher.update(str) + cipher.final
      Base64.strict_encode64(cipher_text)
    end

    def call_token_request(data)
    request_url = 'https://sadad.shaparak.ir/VPG/api/v0/Request/PaymentRequest'
    request_body = {
      'MerchantId' => merchant_id,
      'TerminalId' => terminal_id,
      'Amount' => amount,
      'OrderId' => order_id,
      'LocalDateTime' => DateTime.now,
      'ReturnUrl' => verify_url,
      'SignData' => encrypt_pkcs7(key, data)
    }

    if gateway_account_no && !gateway_account_no.empty? && (company_share > 0)
      request_body.merge({
        'MultiplexingData' => {
          'Type' => "Percentage",
          'MultiplexingRows' => [
            'IbanNumber' => gateway_account_no,
            'Percentage' => company_share
          ]
        }
      })
    end

    response = HTTParty.post(request_url, :body => request_body, format: :json)
    response.parsed_response
  end
end
