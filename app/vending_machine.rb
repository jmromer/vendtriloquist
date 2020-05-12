# frozen_string_literal: true

require "menus/main_menu"
require "menus/payment_menu"
require "menus/purchase_menu"
require "menus/restock_bin_menu"
require "menus/restock_product_menu"
require "utils/printer"

module VendingMachine
  class << self
    def main
      MainMenu.new.read
    rescue ReturnToMainMenu => e
      out.puts(e)
      main
    end

    def purchase
      PurchaseMenu.new.read
    end

    def payment(purchase:)
      PaymentMenu.new(purchase: purchase).read
    end

    def restock
      RestockBinMenu.new.read
    end

    def restock_product(bin:)
      RestockProductMenu.new(bin: bin).read
    end

    def out
      @out || Printer.instance
    end
  end
end
