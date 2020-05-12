# frozen_string_literal: true

require "decorators/bin_decorator"
require "models/bin"

class PurchaseBinDecorator < BinDecorator
  def self.options
    Bin
      .where(row: Bin.select(:row).distinct)
      .group_by(&:row)
      .values
      .map { |bins| decorate bins }
  end

  def self.options_message
    bin_rows = options.map do |bin_row|
      <<~STR
        #{bin_row.map(&:display_name).join(" ")}
        #{bin_row.map(&:display_label).join(" ")}
      STR
    end

    [
      Color.warning("Select a product:"),
      "",
      bin_rows.join
    ].join("\n")
  end
end
