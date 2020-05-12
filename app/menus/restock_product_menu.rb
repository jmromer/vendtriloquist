# frozen_string_literal: true

require "decorators/restock_product_decorator"
require "menus/application_menu"
require "utils/errors"

class RestockProductMenu < ApplicationMenu
  alias selected_product selection

  def initialize(bin:, printer:, source: :restock_menu)
    super(printer: printer, source: source)
    self.decorator = RestockProductDecorator.new
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
    message =
      if selected_bin.fill(product: selected_product.obj)
        decorator.success_message(selected_bin.index, selected_product.name)
      else
        decorator.failure_message(selected_bin.index)
      end

    raise ReturnToMain, message
  end
end
