# frozen_string_literal: true

require "decorators/application_decorator"
require "models/bin"

class BinDecorator < ApplicationDecorator
  alias bin undecorated

  delegate \
    :empty?,
    :index,
    :next_in_stock,
    :next_product,
    :price,
    to: :bin

  def product_name
    next_product&.name || "[sold out]"
  end

  def product_price
    return unless next_product

    l currency.to_dec(next_product.price_int)
  end

  def sold_out?
    empty?
  end

  def display_index
    color.option(index, sold_out?).ljust(10)
  end

  def display_price
    product_price.to_s.ljust(8)
  end

  def display_name
    color.default(product_name, sold_out?).ljust(27)
  end

  def display_label
    "(#{display_index}) #{display_price}"
  end

  def full_label
    return "(#{index}) [sold out]" if empty?

    "(#{index}) #{product_name} #{product_price}"
  end

  def to_s
    index
  end
end
