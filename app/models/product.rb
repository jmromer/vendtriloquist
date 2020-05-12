# frozen_string_literal: true

require "models/application_record"

# A product available for sale
class Product < ApplicationRecord
  has_many :stockings, dependent: :destroy

  validates :name,
            presence: true

  validates :price_atomic,
            presence: true,
            numericality: { greater_than: 0 },
            uniqueness: { scope: :name }
end
