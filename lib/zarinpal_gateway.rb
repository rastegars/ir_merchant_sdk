require 'date'
require 'openssl'
require 'base64'
require 'savon'

class ZarinpalGateway
  class ZarinPalError < StandardError; end

  attr_reader :merchant_id, :amount, :verify_url, :company_share, :gateway_account_no, :description, :wages_description

  def initialize(options = {})
    @merchant_id = options[:merchant_id]
    @amount = options[:amount]
    @company_share = options[:company_share]
    @gateway_account_no = options[:gateway_account_no]
    @verify_url = options[:verify_url]
    description = options[:description]
    @wages_description = options[:wages_description]
  end

  def request_token
    call_token_request
  end

  private
    def call_token_request
    request_url = 'https://sadad.shaparak.ir/VPG/api/v0/Request/PaymentRequest'
    request_body = {
      'MerchantID' => merchant_id,
      'Amount' => amount,
      'Description' => wages_description,
      'CallbackURL' => verify_url,
      'AdditionalData' => ''
    }

    if gateway_account_no && !gateway_account_no.empty? && (company_share > 0)
      request_body = request_body.merge(
        AdditionalData: {
          Wages: {
            gateway_account_no => {
              Amount: company_share, Description: 'سلام‌سینما'
            }
          }
        }.to_json.to_s
      )
    end

    response = Savon.client(wsdl: ENV['zarinpal_wsdl']).call(:payment_request_with_extra, message: request_body)
    results = response.body
    status = results[:payment_request_with_extra_response][:status]

    raise(ZarinPalError) if status.to_i < 100 || !valid?

    results[:payment_request_with_extra_response][:authority]
  end
end
