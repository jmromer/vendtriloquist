# frozen_string_literal: true

require "decorators/restock_product_decorator"
require "menus/application_menu"
require "utils/errors"

class RestockProductMenu < ApplicationMenu
  alias product selection

  def initialize(bin:)
    super()
    self.bin = bin.decorated
  end

  protected

  attr_accessor :bin

  def options
    RestockProductDecorator.options
  end

  def options_message
    RestockProductDecorator.options_message
  end

  def menu_name
    "restock: select a product"
  end

  def make_selection
    options[input]
  end

  def dispatch
    bin.fill(product: product.undecorated)

    raise ReturnToMainMenu, <<~STR
      Filling bin #{bin} with #{product.name}...
      #{Color.success("Bin #{bin} is filled.")}
    STR
  end
end
