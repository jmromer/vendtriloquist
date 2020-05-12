# frozen_string_literal: true

require "db"
require "menus/main_menu"
require "menus/purchase_menu"
require "menus/restock_bin_menu"

module VendingMachine
  def self.router(target = :main_menu, **kwargs)
    DB.connect
    printer = kwargs.fetch(:printer)

    case target&.to_sym
    when :purchase_menu
      PurchaseMenu.new(**kwargs).read
    when :restock_menu
      RestockBinMenu.new(**kwargs).read
    else
      MainMenu.new(**kwargs).read
    end
  rescue Back => e
    kwargs.delete(:source)
    router(e.to_s, **kwargs)
  rescue Route => e
    router(e.to_s, **kwargs)
  rescue Interrupt => e
    router(e.to_s, **kwargs)
  rescue ReturnToMain => e
    printer.puts(e)
    router(**kwargs)
  end
end
