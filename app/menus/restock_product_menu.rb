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

  def decorator
    RestockProductDecorator.new
  end

  def menu_name
    "restock: select a product"
  end

  def make_selection
    options[input]
  end

  def dispatch
    bin.fill(product: product.obj)
    raise ReturnToMainMenu, decorator.success_message(bin.index, product.name)
  end
end
