# frozen_string_literal: true

require "spec_helper"
require "services/change_maker"

RSpec.describe ChangeMaker, type: :service do
  describe ".render_change" do
    it "returns a hash of mapping denomination to quantity of change" do
      till = {
        25 => 1,
        10 => 1,
        5 => 1,
      }
      result = ChangeMaker.render_change(30, till)
      expect(result).to eq({ 25 => 1, 5 => 1 })
    end

    it "returns the minimum quantity of change necessary" do
      till = {
        9 => 1,
        6 => 1,
        5 => 1,
        1 => 1,
      }
      result = ChangeMaker.render_change(11, till)
      expect(result).to eq({ 6 => 1, 5 => 1 })
    end

    it "returns an empty hash if insufficient funds available" do
      till = {
        5 => 1,
        1 => 1,
      }
      result = ChangeMaker.render_change(11, till)
      expect(result).to eq({})
    end

    it "returns non-minimum amount of change if constrained" do
      till = {
        9 => 1,
        6 => 1,
        5 => 0,
        1 => 2,
      }
      result = ChangeMaker.render_change(11, till)
      expect(result).to eq({ 9 => 1, 1 => 2 })
    end

    it "accepts either till ordering" do
      till = {
        0.01 => 2,
        0.02 => 2,
        0.05 => 2,
        0.10 => 2,
        0.20 => 2,
        0.25 => 3,
        1.00 => 2,
        2.00 => 2,
        5.00 => 2,
      }
      result = ChangeMaker.render_change(0.75, till)
      expect(result).to(eq(0.25 => 3))
    end

    it "works with floats" do
      till = {
        100_00 => 5,
        10_00 => 3,
        1_00 => 5,
        50 => 4,
        25 => 2,
        10 => 2,
        1 => 2,
      }
      result = ChangeMaker.render_change(123_21, till)
      expect(result).to(eq(10000 => 1, 1000 => 2, 100 => 3, 10 => 2, 1 => 1))
    end
  end
end
