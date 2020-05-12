# frozen_string_literal: true

require "decorators/application_decorator"
require "models/product"

class RestockProductDecorator < ApplicationDecorator
  delegate :name, to: :obj

  def options
    super(Product.all)
  end

  def options_message
    [
      "Product to fill:",
      "",
      options.values.map(&:last).join("\n"),
    ].join("\n")
  end

  def options_hash_entry(index)
    [
      index.to_s,
      [self,
       "(#{color.option(index)}) #{color.default(name)}"],
    ]
  end

  def success_message(bin_index, product_name)
    <<~STR
      Filling bin #{bin_index} with #{product_name}...
      #{color.success("Bin #{bin_index} is filled.")}
    STR
  end

  def failure_message(bin_index)
    color.error("Sorry, bin #{bin_index} could not be filled.")
  end
end
