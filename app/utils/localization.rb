# coding: utf-8
# frozen_string_literal: true

module Localization
  def localize(amount, locale: :gbp)
    str = Localization.public_send(locale, amount.to_f.abs)
    amount.negative? ? "(#{str})" : str
  end

  alias l localize

  # Render a formatted currency string (localized for GBP)
  def self.gbp(value)
    if value.abs < 1
      format "%<value>dp", value: (value * 100)
    elsif (value - value.to_i).zero?
      format "£%<value>d", value: value
    else
      format "£%<value>.2f", value: value
    end
  end
end
