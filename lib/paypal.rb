require 'logger'
require 'active_support'
require 'active_support/core_ext'
require 'attr_required'
require 'attr_optional'
require 'faraday'

module Paypal
  mattr_reader :api_version, default: '204.0'
  mattr_accessor :logger, default: Logger.new(STDERR, progname: 'Paypal::Express')
  mattr_writer :sandbox, default: false

  ENDPOINT = {
    :production => 'https://www.paypal.com/cgi-bin/webscr',
    :sandbox => 'https://www.sandbox.paypal.com/cgi-bin/webscr'
  }
  POPUP_ENDPOINT = {
    :production => 'https://www.paypal.com/incontext',
    :sandbox => 'https://www.sandbox.paypal.com/incontext'
  }

  def self.environment
    @@sandbox ? :sandbox : :production
  end

  def self.endpoint
    Paypal::ENDPOINT[environment]
  end

  def self.popup_endpoint
    Paypal::POPUP_ENDPOINT[environment]
  end

  def self.log(message, mode = :info)
    self.logger.send(mode, message)
  end

  def self.sandbox?
    @@sandbox
  end

  def self.sandbox!
    @@sandbox = true
  end
end

require 'paypal/util'
require 'paypal/exception'
require 'paypal/exception/http_error'
require 'paypal/exception/api_error'
require 'paypal/base'
require 'paypal/ipn'
require 'paypal/nvp/request'
require 'paypal/nvp/response'
require 'paypal/payment/common/amount'
require 'paypal/express/request'
require 'paypal/express/response'
require 'paypal/payment/request'
require 'paypal/payment/request/item'
require 'paypal/payment/response'
require 'paypal/payment/response/info'
require 'paypal/payment/response/item'
require 'paypal/payment/response/payee_info'
require 'paypal/payment/response/payer'
require 'paypal/payment/response/reference'
require 'paypal/payment/response/refund'
require 'paypal/payment/response/refund_info'
require 'paypal/payment/response/address'
require 'paypal/payment/recurring'
require 'paypal/payment/recurring/activation'
require 'paypal/payment/recurring/billing'
require 'paypal/payment/recurring/summary'
