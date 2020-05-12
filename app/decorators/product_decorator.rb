# frozen_string_literal: true

require "decorators/application_decorator"

class ProductDecorator < ApplicationDecorator
  def self.options(object)
    decorate(object)
      .map
      .with_index(1) { |obj, index| obj.options_hash_entry(index) }
      .to_h
  end

  def price
    l Currency.to_dec price_atomic
  end
end
