module Paypal
  module NVP
    class Request < Base
      attr_required :username, :password, :signature
      attr_optional :subject
      attr_accessor :version

      ENDPOINT = {
        :production => 'https://api-3t.paypal.com/nvp',
        :sandbox => 'https://api-3t.sandbox.paypal.com/nvp'
      }

      def self.endpoint
        ENDPOINT[Paypal.environment]
      end

      def initialize(attributes = {})
        @version = Paypal.api_version
        super
        self.subject ||= ''
      end

      def common_params
        {
          :USER => self.username,
          :PWD => self.password,
          :SIGNATURE => self.signature,
          :SUBJECT => self.subject,
          :VERSION => self.version,
          version: self.version
        }
      end

      def request(method, params = {})
        handle_response do
          post(method, params)
        end
      end

      private

      def post(method, params)
        Faraday.post(self.class.endpoint, common_params.merge(params).merge(:METHOD => method))
      end

      def handle_response
        response = yield
        raise Exception::HttpError.new(response.status, response.reason_phrase, response.body) unless (200..310).include?(response.status)

        result = CGI
          .parse(response.body)
          .each_with_object({}) { |(k, v), obj| obj[k.to_sym] = v.first.to_s }

        raise Exception::APIError.new(result) if result[:ACK] !~ /Success/

        result
      rescue Faraday::Error => e
        raise Exception::HttpError.new(e.response.status, e.response.reason_phrase, e.response.body)
      end
    end
  end
end
