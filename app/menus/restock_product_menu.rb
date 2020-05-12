# frozen_string_literal: true

require "decorators/restock_product_decorator"
require "menus/application_menu"
require "utils/errors"

class RestockProductMenu < ApplicationMenu
  alias selected_product selection

  def initialize(bin:, printer:, source: :restock_menu)
    super(printer: printer, source: source)
    self.decorator = RestockProductDecorator.new(selected_bin: bin)
    self.selected_bin = bin
  end

  protected

  attr_accessor :selected_bin

  def menu_name
    "restock: select a product"
  end

  def make_selection
    options[input]
  end

  def dispatch
    message = decorator.refill_complete_message(
      product: selected_product,
      is_success: selected_bin.fill(product: selected_product),
    )
    raise ReturnToMain, message
  end
end
