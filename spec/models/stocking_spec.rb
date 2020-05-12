# frozen_string_literal: true

require "spec_helper"
require "models/stocking"

RSpec.describe Stocking, type: :model do
  it { should belong_to(:bin).counter_cache(:in_stock_count) }
  it { should belong_to(:product).counter_cache(:in_stock_count) }
  it { should validate_presence_of(:bin) }
  it { should validate_presence_of(:product) }
end
