# frozen_string_literal: true

require "spec_helper"
require "models/product"

RSpec.describe Product, type: :model do
  subject { create(:product) }
  it { should have_many(:stockings) }
  it { should validate_numericality_of(:price_atomic).is_greater_than(0) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price_atomic) }
  it { should validate_uniqueness_of(:price_atomic).scoped_to(:name) }
end
