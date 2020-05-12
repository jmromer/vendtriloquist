# coding: utf-8
# frozen_string_literal: true

require "decorators/purchase_payment_decorator"
require "menus/application_menu"
require "services/payment_processor"
require "utils/errors"

class PaymentMenu < ApplicationMenu
  alias selected_payment selection

  def initialize(purchase:, printer:, source: :purchase_menu)
    super(printer: printer, source: source)
    self.decorator = PurchasePaymentDecorator.new(purchase: purchase)
    self.payment = PaymentProcessor.new(purchase: decorator)
  end

  protected

  attr_accessor :payment

  def make_selection
    options[input]
  end

  # The integer value of the selected payment
  def payment_value
    currency.to_int(selected_payment)
  end

  def dispatch
    self.result_message = payment.process!(value: payment_value)
    raise ReturnToMain, result_message
  rescue InsufficientChange, PaymentFailure => e
    raise ReturnToMain, e.to_s
  rescue BalanceRemaining => e
    self.result_message = e.to_s
    nil
  end
end
