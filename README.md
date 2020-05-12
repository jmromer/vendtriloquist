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

### Models

Manage persistence logic. Since `ActiveRecord` is the ORM here,
models inherit from an `ApplicationRecord` base class.

### Decorators

ViewModel-like objects that manage presentation-related logic.

### Menus

Controller-like coordinating classes that manage the user-interaction loop and
dispatch based on user menu selections.


Dependency Graph
----------------

[![deps][dep-gif]][dep-gif]

[[interactive][dep-graph]]

[dep-gif]: docs/dependency-graph-1.gif
[dep-graph]: https://jakeromer.com/vendtriloquist/index.html
[ascii]: https://asciinema.org/a/zRX0a6GfAZjaHGBebcRqEZ6uz.svg
[ascii-link]: https://asciinema.org/a/zRX0a6GfAZjaHGBebcRqEZ6uz
