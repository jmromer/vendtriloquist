# frozen_string_literal: true

class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price_atomic, null: false
      t.integer :in_stock_count, default: 0, null: false

      t.timestamps null: false
    end

    add_index :products, [:name, :price_atomic], unique: true

    create_table :bins do |t|
      t.string :row, null: false
      t.integer :column, null: false
      t.integer :capacity, default: 2, null: false
      t.integer :in_stock_count, default: 0, null: false

      t.timestamps null: false
    end

    add_index :bins, [:row, :column], unique: true

    create_table :stockings do |t|
      t.belongs_to :bin, index: true, null: false
      t.belongs_to :product, index: true

      t.timestamps null: false
    end

    add_index :stockings, [:bin_id, :product_id]

    create_table :money do |t|
      t.integer :denomination_value, null: false
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
