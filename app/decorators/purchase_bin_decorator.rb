# frozen_string_literal: true

require "decorators/application_decorator"
require "decorators/bin_decorator"
require "models/bin"

class PurchaseBinDecorator < BinDecorator
  def options
    Bin
      .where(row: Bin.select(:row).distinct)
      .group_by(&:row)
      .values
      .map { |bins| self.class.decorate bins }
  end

  def options_message
    bin_rows = options.map do |bin_row|
      <<~STR
        #{bin_row.map(&:display_name).join(" ")}
        #{bin_row.map(&:display_label).join(" ")}
      STR
    end

    [
      color.warning("Select a product:"),
      "",
      bin_rows.join,
    ].join("\n")
  end
end
