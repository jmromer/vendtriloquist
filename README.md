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

### Decorators

ViewModel-like objects that manage presentation-related logic, usually but not
necessarily decorating a model instance.

### Menus

Controller-like coordinating classes that manage the user-interaction loop and
dispatch based on user menu selections.

### Auxiliaries

Utility modules (written as such rather than as junk-drawers — i.e., as general
and depth-prioritizing library-like code), and service objects to manage
complicated workflows, respectively. See `Currency` and `ChangeMaker` for
illustrative examples.

Dependency Graph
----------------

[![deps][dep-gif]][dep-gif]

[[interactive][dep-graph]]

[dep-gif]: docs/dependency-graph.gif
[dep-graph]: https://jakeromer.com/vendtriloquist/index.html
[ascii]: https://asciinema.org/a/zRX0a6GfAZjaHGBebcRqEZ6uz.svg
[ascii-link]: https://asciinema.org/a/zRX0a6GfAZjaHGBebcRqEZ6uz
