# frozen_string_literal: true

require "logger"

logger = Logger.new(STDOUT)

logger.info "Seeding products..."
[
  ["Almond Joy", 1.50],
  ["Butterfinger", 2.50],
  ["Crunch", 1.00],
  ["Dream Bar", 1.25],
].each do |name, price|
  logger.info "product: #{name}: #{price}"
  Product.create!(name: name, price_int: price * 100)
end

logger.info "Seeding bins..."
%w[A B C D].each do |row|
  logger.info "row: #{row}"
  (1..5).each do |col|
    Bin.create!(row: row, column: col)
  end
end

logger.info "Stocking bins with products..."
Product.all.each do |product|
  row = product.name.chars.first
  Bin.where(row: row).each do |bin|
    logger.info "filling bin #{bin.index} with #{bin.capacity} #{product.name}"
    bin.fill(product: product)
  end
end

logger.info "Seeding money..."
Money::VALID_DENOMINATIONS.each do |denomination|
  Money.create!(denomination_value: denomination, quantity: 2)
end

till = MoneyDecorator.decorate.till_localized.map { |e| e.join(": ") }
logger.info "Till: #{till.join(", ")}"

logger.info "Seeding complete."
