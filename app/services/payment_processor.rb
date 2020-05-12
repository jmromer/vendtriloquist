# frozen_string_literal: true

class PaymentProcessor
  def initialize(purchase:)
    self.purchase = PurchasePaymentDecorator.decorate(purchase)
    self.amount_returned = 0
    self.available_change = {}
    self.denominations_received = []
    self.denominations_returned = []
  end

  def process!(value:)
    denominations_received << value

    raise PaymentInvalid, payment_failure_message unless Money.valid?(value)

    ActiveRecord::Base.transaction do
      render_change
      finalize!
    end

    return success_message if paid_in_full?

    raise BalanceRemaining, status_message
  rescue ActiveRecord::RecordInvalid
    raise PaymentFailure, payment_failure_message
  end

  protected

  attr_accessor \
    :amount_returned,
    :available_change,
    :denominations_received,
    :denominations_returned,
    :purchase

  def render_change
    return unless change_due?

    self.available_change =
      ChangeMaker.render_change(change_due.abs, Money.till_values)

    raise InsufficientChange, insufficient_change_message if insufficient_change?

    self.denominations_returned = available_change_denominations
    self.amount_returned += available_change_denominations.sum
  end

  def finalize!
    return unless paid_in_full?

    Money.remove_from_till!(value_counts: available_change)

    money_received = Counter.new(denominations_received).counts
    Money.add_to_till!(value_counts: money_received)

    purchase.destroy!
  end

  def amount_received
    denominations_received.sum
  end

  def amount_due
    purchase.price_int
  end

  def amount_due?
    balance_remaining.positive?
  end

  def available_change_total
    available_change.to_a.map { |denom, qty| denom * qty }.sum
  end

  def available_change_denominations
    available_change.to_a.map { |amt, qty| [amt] * qty }.flatten
  end

  def balance_remaining
    amount_due - amount_received + amount_returned
  end

  def change_due
    -balance_remaining
  end

  def change_due?
    change_due.positive?
  end

  def insufficient_change?
    return false unless change_due?

    change_due > available_change_total
  end

  def paid_in_full?
    balance_remaining.zero?
  end

  def payment_failure_message
    purchase.payment_failure_message(amount_received)
  end

  def status_message
    purchase.balance_remaining_message(balance_remaining)
  end

  def insufficient_change_message
    purchase.change_insufficient_message(amount_received)
  end

  def success_message
    purchase.success_message(amount_received, denominations_returned)
  end
end
