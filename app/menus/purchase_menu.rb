# frozen_string_literal: true

require "decorators/purchase_bin_decorator"
require "menus/application_menu"
require "menus/payment_menu"

class PurchaseMenu < ApplicationMenu
  alias selected_bin selection

  def initialize(printer:, source: :main_menu)
    super
    self.decorator = PurchaseBinDecorator.new
  end

  protected

  def make_selection
    selected_bin = Bin.find_by_index(input)&.decorated
    [selected_bin, selected_bin&.full_label]
  end

  def dispatch
    if selected_bin.sold_out?
      self.result_message = "Sold out. Please try another item."
      return false
    end

    PaymentMenu.new(
      purchase: selected_bin.next_in_stock,
      printer: out,
    ).read
  end
end
