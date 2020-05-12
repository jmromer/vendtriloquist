vendtriloquist
==============

[![asciicast][ascii]][ascii-link]

An experimental implementation of a TUI that models a vending machine.
Mostly an exercise in OOP.

Requirements
------------

- Ruby 2.6.3
- SQLite3

Installation
------------

Issue `bin/setup` to install dependencies and set up the database.

Usage
-------

Issue `bin/start` to start the TUI.

Tests
-----

Issue `bundle exec rspec` to run the test suite. UI-managing components are
designed for testability but are left untested for now.

Design
---------

The app architecture draws inspiration from MVC- and MVVM-architected web apps.

The analagous high-level concepts in this setting are Models, Decorators, Menus,
and Auxiliaries, or MDMA — because drugs, lol.

### `VendingMachine`

A router-like coordinating module.

### Models

Manage persistence logic. Since `ActiveRecord` is the ORM here,
models inherit from an `ApplicationRecord` base class.

<details>
<summary>app/models/product.rb</summary>

```rb
# app/models/product.rb L5-16 (3af30162)

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
```
<sup>[[source](https://github.com/jmromer/vendtriloquist/blob/3af30162/app/models/product.rb#L5-L16)]</sup>
</details>

### Decorators

ViewModel-like objects that manage presentation-related logic, usually but not
necessarily decorating a model instance.

<details>
<summary>app/decorators/main_menu_decorator.rb</summary>

```rb
# app/decorators/main_menu_decorator.rb L5-24 (3af30162)

class MainMenuDecorator < ApplicationDecorator
  def self.options
    @options ||= {
      "1" => [:purchase, "Make a purchase"],
      "2" => [:restock, "Add inventory"],
    }.freeze
  end

  def self.options_message
    [
      Color.warning("Main menu"),
      "",
      options.map { |k, (_, v)| options_entry(k, v) }.join("\n"),
    ].join("\n")
  end

  def self.options_entry(k, v)
    "(#{Color.option(k)}) #{v}"
  end
end
```
<sup>[[source](https://github.com/jmromer/vendtriloquist/blob/3af30162/app/decorators/main_menu_decorator.rb#L5-L24)]</sup>
</details>

### Menus

Controller-like coordinating classes that manage the user-interaction loop and
dispatch based on user menu selections.

<details>
<summary>app/menus/application_menu.rb</summary>

```rb
# app/menus/application_menu.rb L15-45 (3af30162)

def read
  loop do
    if options&.empty?
      out.puts Color.error("None available.")
      break
    end

    out.puts main_message
    self.input = Readline.readline(prompt)&.strip

    case input
    when nil
      out.puts
      break
    when "q", "Q"
      raise Quit
    else
      Readline::HISTORY.push(input)
      self.selected_option = make_selection
    end

    if selection
      out.puts(Color.default(valid_message))
      unwind = dispatch
      break if unwind
    else
      out.puts(Color.error(invalid_message))
      next
    end
  end
end
```
<sup>[[source](https://github.com/jmromer/vendtriloquist/blob/3af30162/app/menus/application_menu.rb#L15-L45)]</sup>
</details>

### Auxiliaries

Utility modules (written as such rather than as junk-drawers — i.e., as general
and depth-prioritizing library-like code), and service objects to manage
complicated workflows, respectively. See `Currency` and `ChangeMaker` for
illustrative examples.

<details>
<summary>app/utils/currency.rb</summary>

```rb
# app/utils/currency.rb L3-15 (3af30162)

module Currency
  def self.to_int(amt)
    case amt
    when Integer
      amt
    when Float, BigDecimal
      (amt * 100).to_i
    when Array
      amt.map { |e| to_int(e) }
    else
      raise ArgumentError, "Invalid value: '#{amt}' (#{amt.class})"
    end
  end
```
<sup>[[source](https://github.com/jmromer/vendtriloquist/blob/3af30162/app/utils/currency.rb#L3-L15)]</sup>
</details>

<details>
<summary>app/services/change_maker.rb</summary>

```rb
# app/services/change_maker.rb L3-17 (3af30162)

module ChangeMaker
  class << self
    # Render a target `amount` of change.
    # Expects and returns integer currency values.
    #
    # Parameters:
    # - amount: Integer. The total amount of change to render
    # - till: Hash. Mapping available denominations to quantities
    # - trials: Integer. The number of attempts to make
    #
    # Return a Hash mapping denomination amounts to quantities
    #
    # Return an empty Hash if the target amount cannot be rendered with the
    # given denominations
    def render_change(amount, till, trials = 15)
```
<sup>[[source](https://github.com/jmromer/vendtriloquist/blob/3af30162/app/services/change_maker.rb#L3-L17)]</sup>
</details>

Dependency Graph
----------------

[![deps][dep-gif]][dep-gif]

[[interactive][dep-graph]]

[dep-gif]: docs/dependency-graph.gif
[dep-graph]: https://jakeromer.com/vendtriloquist/index.html
[ascii]: https://asciinema.org/a/zRX0a6GfAZjaHGBebcRqEZ6uz.svg
[ascii-link]: https://asciinema.org/a/zRX0a6GfAZjaHGBebcRqEZ6uz
