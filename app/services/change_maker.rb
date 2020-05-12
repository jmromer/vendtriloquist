# frozen_string_literal: true

module ChangeMaker
  class << self
    # Render a target `amount` of change.
    # Expects and returns integer currency values.
    #
    # Parameters:
    # - amount: Integer. The total amount of change to render
    # - till: Hash. Mapping available denominations to quantities
    # - trials: Integer. The number of attempts to make
    #
    # Return a Hash mapping denomination amounts to quantities
    #
    # Return an empty Hash if the target amount cannot be rendered with the
    # given denominations
    def render_change(amount, till, trials = 15)
      change_set = Set.new

      trials.times do |trial|
        change = Hash.new(0)
        balance = amount
        money = trial.zero? ? till.sort_by(&:first).reverse : till.to_a.shuffle

        money.each do |denomination, qty|
          break if balance.zero?

          remaining_qty = qty

          while balance.positive?
            break if denomination > balance
            break if remaining_qty.zero?

            balance -= denomination
            change[denomination] += 1

            remaining_qty -= 1
          end
        end

        change_set.add(change) if balance.zero?
      end

      change_set
        .min_by { |change| change.values.sum }
        .to_h
        .map { |denom, qty| [denom, qty] }
        .sort_by { |denom, _| -denom }
        .to_h
    end
  end
end
