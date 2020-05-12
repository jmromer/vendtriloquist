# frozen_string_literal: true

FactoryBot.define do
  factory :bin do
    sequence(:row) { |n| ("A".."Z").entries.slice(n % 26) }
    sequence(:column) { |n| (n % 9).succ }
    sequence(:capacity) { 2 }
  end

  factory :product do
    sequence(:name) { |n| "Candy Bar #{n}" }
    sequence(:price_int) do
      [(1..5), [0, 25, 50]].map { |n| n.entries.sample }.join .to_i
    end
  end

  factory :stocking do
    product
    bin
  end

  factory :money do
    denomination_value { Money::VALID_DENOMINATIONS.sample }
    quantity { 10 }
  end
end
