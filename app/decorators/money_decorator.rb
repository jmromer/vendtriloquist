# frozen_string_literal: true

class MoneyDecorator < ApplicationDecorator
  def self.denomination_options
    Money::VALID_DENOMINATIONS
      .map { |val| currency.to_dec(val) }
      .map.with_index(1) { |amt, idx| [idx.to_s, [amt, "(#{color.option(idx)}) #{l(amt)}"]] }
      .to_h
  end

  # the till, as decimals
  def self.till
    Money
      .till_values
      .map { |val, qty| [currency.to_dec(val), qty] }
      .to_h
  end

  def self.till_localized
    Money.till.map { |amt, qty| [l(amt), qty] }.to_h
  end

  def to_s
    l currency.to_dec denomination_value
  end
end
