# frozen_string_literal: true

require "spec_helper"
require "services/payment_processor"

RSpec.describe PaymentProcessor, type: :service do
  describe ".process!" do
    context "given an invalid payment value" do
      it "raises a failure exception" do
        product = create(:product, price_int: 100)
        purchase = create(:stocking, product: product)

        payment = PaymentProcessor.new(purchase: purchase)

        expect { payment.process!(value: 18_00) }
          .to(raise_error(PaymentInvalid, /Refunded:.+18/))
      end
    end

    context "given exact change" do
      before do
        create(:money, denomination_value: 1_00, quantity: 0)
        create(:stocking, product: create(:product, price_int: 1_00))
      end

      it "completes without exception, returning a message" do
        payment = PaymentProcessor.new(purchase: Stocking.first)
        result = payment.process!(value: 1_00)
        expect(result).to match(/Amount charged:.+1/)
      end

      it "adds to the till" do
        expect(Money.till_values).to eq(1_00 => 0)

        payment = PaymentProcessor.new(purchase: Stocking.first)
        payment.process!(value: 1_00)

        expect(Money.till_values).to eq(1_00 => 1)
      end

      it "updates the stock of product" do
        expect(Stocking.count).to eq(1)

        payment = PaymentProcessor.new(purchase: Stocking.first)
        payment.process!(value: 1_00)

        expect(Stocking.count).to eq(0)
      end
    end

    context "given less than the full amount" do
      before do
        create(:money, denomination_value: 1_00, quantity: 1)
        create(:stocking, product: create(:product, price_int: 1_00))
      end

      it "raises BalanceRemaining" do
        payment = PaymentProcessor.new(purchase: Stocking.first)
        expect { payment.process!(value: 50) }
          .to(raise_error(BalanceRemaining, /remaining:.+50p/))
      end

      it "has no effect on the till or stock of product" do
        expect(Stocking.count).to eq(1)
        expect(Money.till_values).to eq(1_00 => 1)

        payment = PaymentProcessor.new(purchase: Stocking.first)
        expect { payment.process!(value: 50) }.to raise_error(BalanceRemaining)

        expect(Stocking.count).to eq(1)
        expect(Money.till_values).to eq(1_00 => 1)
      end
    end

    context "given change is due and available" do
      before do
        create(:money, denomination_value: 2_00, quantity: 0)
        create(:money, denomination_value: 50, quantity: 1)
        create(:stocking, product: create(:product, price_int: 1_50))
      end

      it "completes without exception, returning a message" do
        payment = PaymentProcessor.new(purchase: Stocking.first)

        result = payment.process!(value: 2_00)

        expect(result).to match(/Change rendered.+50p/)
      end

      it "adds to and removes from the till" do
        expect(Money.till_values).to eq(2_00 => 0, 50 => 1)

        payment = PaymentProcessor.new(purchase: Stocking.first)
        payment.process!(value: 2_00)

        expect(Money.till_values).to eq(2_00 => 1, 50 => 0)
      end

      it "updates the stock of product" do
        expect(Stocking.count).to eq(1)

        payment = PaymentProcessor.new(purchase: Stocking.first)
        payment.process!(value: 2_00)

        expect(Stocking.count).to eq(0)
      end
    end

    context "given change is due but unavailable" do
      before do
        create(:money, denomination_value: 1_00, quantity: 0)
        create(:money, denomination_value: 1, quantity: 2)
        create(:stocking, product: create(:product, price_int: 1_00))
      end

      it "raises InsufficientChange" do
        payment = PaymentProcessor.new(purchase: Stocking.first)
        expect { payment.process!(value: 2_00) }
          .to(raise_error(InsufficientChange, /Insufficient change available/))
      end

      it "has no effect on the till or stock of product" do
        expect(Money.till_values).to eq(1_00 => 0, 1 => 2)
        expect(Stocking.count).to eq(1)

        payment = PaymentProcessor.new(purchase: Stocking.first)
        expect { payment.process!(value: 2_00) }.to(raise_error(InsufficientChange))

        expect(Stocking.count).to eq(1)
        expect(Money.till_values).to eq(1_00 => 0, 1 => 2)
      end
    end
  end
end
