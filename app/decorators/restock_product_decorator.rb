# frozen_string_literal: true

require "decorators/application_decorator"
require "models/product"

class RestockProductDecorator < ApplicationDecorator
  delegate :index, to: :selected_bin, prefix: true

  attr_accessor :selected_bin

  def initialize(selected_bin:)
    self.selected_bin = selected_bin
  end

  def options
    Product.all.map.with_index(1) do |product, number|
      [
        number.to_s,
        [product,
         "(#{color.option(number)}) #{color.default(product.name)}"],
      ]
    end.to_h
  end

  def options_message
    [
      "Product to fill:",
      "",
      options.values.map(&:last).join("\n"),
    ].join("\n")
  end

  def refill_complete_message(product:, is_success:)
    if is_success
      success_message(product.name)
    else
      failure_message
    end
  end

  def success_message(product_name)
    <<~STR
      Filling bin #{selected_bin_index} with #{product_name}...
      #{color.success("Bin #{selected_bin_index} is filled.")}
    STR
  end

  def failure_message
    color.error("Sorry, bin #{selected_bin_index} could not be filled.")
  end
end
