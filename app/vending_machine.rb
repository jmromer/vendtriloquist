# frozen_string_literal: true

require "db"
require "menus/main_menu"
require "menus/purchase_menu"
require "menus/restock_bin_menu"

module VendingMachine
  def self.router(target = nil, **kwargs)
    DB.connect
    printer = kwargs.fetch(:printer)

    case target&.to_sym
    when :purchase
      PurchaseMenu.new(**kwargs).read
    when :restock_select_bin
      RestockBinMenu.new(**kwargs).read
    else
      MainMenu.new(**kwargs).read
    end
  rescue Back => e
    kwargs.delete(:source)
    router(e.to_s, **kwargs)
  rescue Dispatch => e
    router(e.to_s, **kwargs)
  rescue Interrupt => e
    router(e.to_s, **kwargs)
  rescue ReturnToMainMenu => e
    printer.puts(e)
    router(:main, **kwargs)
  end
end
