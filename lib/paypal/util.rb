require "bigdecimal"

module Paypal
  module Util

    def self.formatted_amount(x)
      x = '0' if x == '' || x.nil?
      sprintf '%0.2f', BigDecimal.new(x.to_s).round(2)
    end

    def self.to_numeric(x)
      string = x.to_s
      string = "0" if string == ""  # Ruby 2.5 compatibility.

      decimal = BigDecimal(string)

      if decimal == x.to_i
        x.to_i
      else
        decimal
      end
    end

    def numeric_attribute?(key)
      !!(key.to_s =~ /(amount|frequency|cycles|paid)/)
    end

    def ==(other)
      instance_variables.all? do |key|
        instance_variable_get(key) == other.instance_variable_get(key)
      end
    end

  end
end
