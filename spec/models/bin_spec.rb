# frozen_string_literal: true

require "spec_helper"
require "models/bin"

RSpec.describe Bin, type: :model do
  subject { create(:bin) }

  it { should have_many(:products).through(:stockings) }
  it { should have_many(:stockings) }
  it { should validate_inclusion_of(:column).in_range(1..9) }
  it { should validate_length_of(:row).is_equal_to(1) }
  it { should validate_presence_of(:capacity) }
  it { should validate_presence_of(:column) }
  it { should validate_presence_of(:in_stock_count) }
  it { should validate_presence_of(:row) }
  it { should validate_uniqueness_of(:column).scoped_to(:row) }
  it { should validate_uniqueness_of(:row).scoped_to(:column) }

  describe "#fill" do
    it "fills the given bin to capacity in FILO order" do
      prod1, prod2 = create_list(:product, 2)
      bin = create(:bin, capacity: 3)
      create(:stocking, bin: bin, product: prod1)
      expect(bin.openings_count).to be_positive
      expect(bin.next_product).to eq(prod1)

      bin.fill(product: prod2)

      expect(bin).to_not be_empty
      expect(bin.openings_count).to be_zero
      expect(bin.next_product).to eq(prod2)
    end
  end

  describe "#find_by_index" do
    context "given a valid index" do
      it "returns the bin object" do
        bin = create(:bin, row: "A", column: 8)
        expect(Bin.find_by_index("A8")).to eq(bin)
        expect(Bin.find_by_index("a8")).to eq(bin)
      end
    end

    context "given a invalid index" do
      it "returns nil" do
        expect(Bin.find_by_index("Z9")).to be_nil
        expect(Bin.find_by_index("")).to be_nil
        expect(Bin.find_by_index("A11")).to be_nil
      end
    end
  end
end
