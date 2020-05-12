# frozen_string_literal: true

require "decorators/restock_product_decorator"
require "menus/application_menu"
require "utils/errors"

class RestockProductMenu < ApplicationMenu
  alias product selection

  def initialize(bin:, printer:, source: :restock_select_bin)
    super(printer: printer, source: source)
    self.bin = bin
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
    bin.fill(product: product.obj)

    # TODO: copy to a decorator
    raise ReturnToMainMenu, <<~STR
      Filling bin #{bin} with #{product.name}...
      #{color.success("Bin #{bin} is filled.")}
    STR
  end
end
