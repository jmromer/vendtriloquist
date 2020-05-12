# frozen_string_literal: true

require "models/application_record"

# An individual product in a bin
class Stocking < ApplicationRecord
  belongs_to :bin, counter_cache: :in_stock_count
  belongs_to :product, counter_cache: :in_stock_count

  validates :bin, :product, presence: true

  delegate :price_atomic, to: :product
  delegate :index, to: :bin, prefix: true
end
