# frozen_string_literal: true

require "models/application_record"
require "models/stocking"
require "models/product"

# A vending machine row
class Bin < ApplicationRecord
  validates :row,
            presence: true,
            format: { with: /\A[A-Z]\z/ },
            length: { is: 1 },
            uniqueness: { scope: :column }

  validates :column,
            presence: true,
            inclusion: { in: 1..9 },
            uniqueness: { scope: :row }

  validates :capacity,
            presence: true,
            numericality: true

  validates :in_stock_count, presence: true

  has_many :stockings, dependent: :destroy
  has_many :products, through: :stockings

  delegate :empty?, to: :stockings

  scope :sold_out, -> { where.not(id: Stocking.select(:bin_id)) }
  scope :below_capacity, -> { where("in_stock_count < capacity") }

  def self.find_by_index(index)
    return unless index.length == 2

    row, column = index.upcase.chars
    find_by(row: row, column: column)
  end

  def fill(product:)
    transaction do
      openings_count.times do
        stockings.create!(product: product)
      end
    end
  rescue ActiveRecord::RecordInvalid
  end

  def index
    [row, column].join
  end

  def openings_count
    capacity - stockings.count
  end

  def next_in_stock
    stockings.last
  end

  def next_product
    next_in_stock&.product
  end
end
