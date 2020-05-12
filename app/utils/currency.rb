# frozen_string_literal: true

module Currency
  def self.to_int(amt)
    case amt
    when Integer
      amt
    when Float, BigDecimal
      (amt * 100).to_i
    when Array
      amt.map { |e| to_int(e) }
    else
      raise ArgumentError, "Invalid value: '#{amt}' (#{amt.class})"
    end
  end

  def self.to_dec(amt)
    case amt
    when Float, BigDecimal
      amt
    when Integer
      amt / 100.0
    when Array
      amt.map { |e| to_dec(e) }
    else
      raise ArgumentError, "Invalid value: '#{amt}' (#{amt.class})"
    end
  end
end
