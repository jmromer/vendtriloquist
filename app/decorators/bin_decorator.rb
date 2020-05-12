# frozen_string_literal: true

require "decorators/application_decorator"
require "decorators/product_decorator"

class BinDecorator < ApplicationDecorator
  def next_product
    undecorated.next_product&.decorated
  end

  def product_name
    next_product&.name || "[sold out]"
  end

  def product_price
    next_product&.price
  end

  def sold_out?
    empty?
  end

  def display_index
    Color.option(index, sold_out?).ljust(10)
  end

  def display_price
    product_price.to_s.ljust(8)
  end

  def display_name
    Color.default(product_name, sold_out?).ljust(27)
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
