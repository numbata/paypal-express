module Paypal
  module IPN
    def self.endpoint
      _endpoint_ = URI.parse Paypal.endpoint
      _endpoint_.query = {
        :cmd => '_notify-validate'
      }.to_query
      _endpoint_.to_s
    end

    def self.verify!(raw_post)
      response = Paypal.connection.post do |req|
        req.url endpoint
        req.body = raw_post
      end

      case response.body
      when 'VERIFIED'
        true
      else
        raise Exception::APIError.new(response.body)
      end
    end
  end
end
