# frozen_string_literal: true

require "decorators/bin_decorator"

class RestockBinDecorator < BinDecorator
  alias bin undecorated

  delegate \
    :capacity,
    :in_stock_count,
    to: :bin

  def options
    self.class
      .decorate(Bin.below_capacity)
      .map(&:options_hash_entry)
      .to_h
  end

  def options_message
    [
      "Select a bin to refill:",
      "",
      options.values.map(&:last).join("\n"),
    ].join("\n")
  end

  def options_hash_entry
    slack_amount =
      if in_stock_count.zero?
        "empty"
      else
        "#{capacity - in_stock_count}/#{capacity} unfilled"
      end

    [index, [self, "(#{color.option(index)}) #{slack_amount}"]]
  end
end
