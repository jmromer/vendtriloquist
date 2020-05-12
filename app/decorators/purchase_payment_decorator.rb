# coding: utf-8
# frozen_string_literal: true

require "decorators/application_decorator"
require "decorators/money_decorator"
require "models/money"
require "utils/currency"

class PurchasePaymentDecorator < ApplicationDecorator
  alias stocking undecorated

  delegate \
    :destroy!,
    :price_atomic,
    :product,
    to: :stocking

  attr_accessor :money

  def initialize(purchase:, money: nil)
    super(purchase)
    self.money = money || MoneyDecorator.new
  end

  def options
    money.denomination_options
  end

  def options_message
    <<~STR
      #{color.warning("Insert currency")}

      #{options.values.map(&:last).join(" ")}
    STR
  end

  def price
    currency.to_dec price_atomic
  end

  def change_rendered_message(change_rendered)
    return if change_rendered.empty?

    change =
      change_rendered
        .map { |value| l(currency.to_dec(value)) }

    "Change rendered: #{change.join(", ")}"
  end

  def purchase_price_message
    "Amount charged: #{l(price)}"
  end

  def amount_received_message(amount_received)
    total = l(currency.to_dec(amount_received))
    "Amount received: #{total}"
  end

  def balance_remaining_message(balance_remaining)
    [
      "Vending #{product.name} #{l price}...",
      "Balance remaining: #{color.warning l currency.to_dec balance_remaining}",
    ].join("\n")
  end

  def payment_failure_message(amount_refunded)
    color.error(<<~STR)
      Could not process your payment.

      Refunded: #{l currency.to_dec amount_refunded}
    STR
  end

  def change_insufficient_message(amount_refunded)
    till =
      money
        .till_localized
        .select { |_amt, qty| qty.positive? }
        .map { |e| e.join(": ") }
        .join(", ")

    color.error(<<~STR)
      Insufficient change available. Purchase canceled.
      In the till currently: #{till.empty? ? "[empty]" : till}
      Refunded: #{l currency.to_dec amount_refunded}
    STR
  end

  def success_message(amount_received, change_rendered)
    [
      color.success("Thanks!"),
      purchase_price_message,
      amount_received_message(amount_received),
      change_rendered_message(change_rendered),
      "Enjoy your #{product.name} ✨",
    ].compact.join("\n")
  end
end
