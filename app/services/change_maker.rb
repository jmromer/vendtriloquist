# frozen_string_literal: true

module ChangeMaker
  class << self
    # Render a target `amount` of change, subject to a denomination availability
    # constraint represented by `till`.
    #
    # Expects and returns integer currency values.
    #
    # Parameters:
    #
    # - amount: Integer. The total amount of change to render
    # - till: Hashish. Map or tuple list of the form `{denomination => quantity`
    # - trials: Integer. The number of attempts to make
    #
    # Note that the first trial takes the greedy approach, while subsequent
    # trials are randomized. I may refactor to implement the asymptotically
    # optimal solution, but:
    #
    # 1. This solution is expedient to implement, easy to understand, and
    #    bounded by fixed parameter magnitudes (`till`, `trials`) such that it
    #    has a net cost advantage over the optimum solution.
    #
    # 2. As always, the performance difference between asymptotically optimal
    #    and suboptimal implementations isn't guaranteed to be monotonic over
    #    the entire range of inputs, so a comparison benchmark would be needed
    #    to determine optimality given the concrete constraints of the
    #    application.
    #
    # Return a Hash, possibly empty, mapping denomination amounts to quantities
    def render_change(amount, till, trials = 15)
      change_set = Set.new
      till = till.sort_by(&:first).reverse

      trials.times do |trial|
        denomination_qtys = trial.zero? ? till : till.shuffle
        change_set.add try_making_change(amount, denomination_qtys)
      end

      # Return least by number of denominations
      # NB: nil.to_h returns {}
      change_set
        .to_a
        .compact
        .min_by { |change| change.values.sum }
        .to_h
        .sort_by { |denom, _| -denom }
        .to_h
    end

    def try_making_change(amount, till, change=Hash.new(0))
      remaining_amt = amount

      till.each do |denomination, qty|
        break if remaining_amt.zero?

        remaining_qty = qty

        while remaining_amt.positive?
          break if denomination > remaining_amt
          break if remaining_qty.zero?

          remaining_amt -= denomination
          change[denomination] += 1

          remaining_qty -= 1
        end
      end

      return change if remaining_amt.zero?
    end
  end
end
