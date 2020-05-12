# frozen_string_literal: true

class PaymentProcessor
  def initialize(purchase:)
    self.purchase = purchase
    self.amount_returned = 0
    self.available_change = {}
    self.denominations_received = []
    self.denominations_returned = []
  end

  def process!(face_value:)
    denominations_received << MoneyDecorator.currency.to_int(face_value)

    ActiveRecord::Base.transaction do
      render_change
      finalize!
    end

    if paid_in_full?
      success_message
    else
      raise BalanceRemaining, status_message
    end
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
    purchase.price_atomic
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
