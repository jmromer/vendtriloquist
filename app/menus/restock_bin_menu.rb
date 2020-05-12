# frozen_string_literal: true

require "decorators/restock_bin_decorator"
require "menus/application_menu"
require "menus/restock_product_menu"

class RestockBinMenu < ApplicationMenu
  alias selected_bin selection

  def initialize(printer:, source: :main_menu)
    super
    self.decorator = RestockBinDecorator.new
  end

  protected

  def menu_name
    "restock: select a bin"
  end

  def make_selection
    options[input.upcase]
  end

  def dispatch
    RestockProductMenu.new(
      bin: selected_bin.obj,
      printer: out,
    ).read
  end
end
