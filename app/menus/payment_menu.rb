# coding: utf-8
# frozen_string_literal: true

require "decorators/purchase_payment_decorator"
require "menus/application_menu"
require "services/payment_processor"
require "utils/errors"

class PaymentMenu < ApplicationMenu
  alias selected_payment selection

  def initialize(purchase:, printer:, source: :purchase)
    super(printer: printer, source: source)
    purchase = PurchasePaymentDecorator.new(purchase)
    self.payment = PaymentProcessor.new(purchase: purchase)
  end

  protected

  def decorator
    PurchasePaymentDecorator.new
  end

  delegate :currency, to: :decorator

  attr_accessor :payment

  def make_selection
    options[input]
  end

  def dispatch
    payment_value = currency.to_int(selected_payment)
    self.result_message = payment.process!(value: payment_value)
    raise ReturnToMainMenu, result_message
  rescue InsufficientChange, PaymentFailure => e
    raise ReturnToMainMenu, e.to_s
  rescue BalanceRemaining => e
    self.result_message = e.to_s
    nil
  end
end
