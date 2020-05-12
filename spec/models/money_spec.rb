# frozen_string_literal: true

require "spec_helper"
require "models/money"

RSpec.describe Money, type: :model do
  subject { create(:money) }
  it { should validate_numericality_of(:denomination_value).is_greater_than(0) }
  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of(:denomination_value) }
  it { should validate_presence_of(:quantity) }
  it { should validate_uniqueness_of(:denomination_value) }

  describe ".add_to_till!" do
    it "adds the list of denominations to the till" do
      create(:money, denomination_value: 100, quantity: 0)
      create(:money, denomination_value: 50, quantity: 1)

      Money.add_to_till!(value_counts: { 100 => 3, 50 => 1 })

      expect(Money.till_values).to eq(100 => 3, 50 => 2)
    end

    it "ignores invalid denominations" do
      create(:money, denomination_value: 100, quantity: 0)

      Money.add_to_till!(value_counts: { 100 => 2, 5500 => 1 })

      expect(Money.till_values).to eq(100 => 2)
    end

    it "no-ops if given an empty till" do
      create(:money, denomination_value: 100, quantity: 1)

      Money.add_to_till!(value_counts: {})
      Money.add_to_till!(value_counts: nil)

      expect(Money.till_values).to eq(100 => 1)
    end
  end

  describe ".remove_from_till!" do
    it "removes the given denomination counts from the till" do
      create(:money, denomination_value: 100, quantity: 1)
      create(:money, denomination_value: 50, quantity: 1)

      Money.remove_from_till!(value_counts: { 100 => 1 })

      expect(Money.till_values).to eq(100 => 0, 50 => 1)
    end

    it "no-ops if unable to remove as requested" do
      create(:money, denomination_value: 1, quantity: 1)
      original_till = Money.till_values

      with_invalid_amt = { 100 => 1, 50 => 1 }
      Money.remove_from_till!(value_counts: with_invalid_amt)

      expect(Money.till_values).to eq(original_till)
    end

    it "no-ops if given an empty till" do
      create(:money, denomination_value: 1, quantity: 1)
      original_till = Money.till_values

      Money.remove_from_till!(value_counts: {})
      expect(Money.till_values).to eq(original_till)

      Money.remove_from_till!(value_counts: nil)
      expect(Money.till_values).to eq(original_till)
    end

    it "raises if quantity is invalid" do
      create(:money, denomination_value: 100, quantity: 1)
      original_till = Money.till_values

      expect {
        with_invalid_qty = { 100 => 3 }
        Money.remove_from_till!(value_counts: with_invalid_qty)
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect(Money.till_values).to eq(original_till)
    end
  end

  describe ".till" do
    it "returns a hash of available currencies, localized, and quantities" do
      monies = [
        create(:money, denomination_value: 1, quantity: 2),
        create(:money, denomination_value: 2, quantity: 0),
        create(:money, denomination_value: 5, quantity: 10),
        create(:money, denomination_value: 10, quantity: 3),
      ]

      monies.zip(Money.till_values).each do |money, (amount, qty)|
        expect(money.denomination_value).to eq(amount)
        expect(money.quantity).to eq(qty)
      end
    end
  end
end
