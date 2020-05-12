# frozen_string_literal: true

require "decorators/bin_decorator"

class RestockBinDecorator < BinDecorator
  def self.options
    super(Bin.below_capacity)
  end

  def self.options_message
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

    [index, [self, "(#{Color.option(index)}) #{slack_amount}"]]
  end
end
