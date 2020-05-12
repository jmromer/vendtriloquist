# frozen_string_literal: true

require "decorators/application_decorator"
require "models/money"

class MoneyDecorator < ApplicationDecorator
  def denomination_options
    Money::VALID_DENOMINATIONS
      .map { |val| currency.to_dec(val) }
      .map.with_index(1) { |amt, idx| [idx.to_s, [amt, "(#{color.option(idx)}) #{l(amt)}"]] }
      .to_h
  end

  def till_localized
    Money
      .till_values
      .map { |amt, qty| [l(currency.to_dec(amt)), qty] }
      .to_h
  end

  def to_s
    l currency.to_dec denomination_value
  end
end
