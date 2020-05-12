# frozen_string_literal: true

require "decorators/product_decorator"
require "models/product"

class RestockProductDecorator < ProductDecorator
  delegate :name, to: :obj

  def self.options
    super(Product.all)
  end

  def self.options_message
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
      "(#{color.option(index)}) #{color.default(name)}"
     ]
    ]
  end
end
