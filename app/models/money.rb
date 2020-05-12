# coding: utf-8
# frozen_string_literal: true

require "models/application_record"
require "services/change_maker"
require "utils/counter"
require "utils/currency"

class Money < ApplicationRecord
  VALID_DENOMINATIONS = [
    2_00,
    1_00,
    50,
    20,
    10,
    5,
    2,
    1,
  ].freeze

  validates :denomination_value,
            presence: true,
            uniqueness: true,
            numericality: { greater_than: 0 },
            inclusion: { in: VALID_DENOMINATIONS }

  validates :quantity,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  def self.valid?(denomination)
    VALID_DENOMINATIONS.include?(denomination)
  end

  def self.till_values
    pluck(:denomination_value, :quantity).to_h
  end

  def self.add_to_till!(value_counts:)
    update_quantities!(value_counts) { |curr_qty, delta| curr_qty + delta }
  end

  def self.remove_from_till!(value_counts:)
    update_quantities!(value_counts) { |curr_qty, delta| curr_qty - delta }
  end

  def self.update_quantities!(value_counts)
    return if value_counts.to_h.empty?

    transaction do
      where(denomination_value: value_counts.keys).find_each do |till_slot|
        curr_qty = till_slot.quantity
        delta_qty = value_counts.fetch(till_slot.denomination_value)
        updated_qty = yield(curr_qty, delta_qty)
        till_slot.quantity = updated_qty
        till_slot.save!
      end
    end
  end
end
