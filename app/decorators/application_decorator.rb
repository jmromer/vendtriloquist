# frozen_string_literal: true

require "utils/localization"

class ApplicationDecorator
  include Localization
  extend Localization

  attr_accessor :obj

  def initialize(obj)
    self.obj = obj
  end

  def self.decorate(object)
    return new(object) unless object.respond_to?(:map)

    object.map { |obj| new(obj) }
  end

  def self.options(object)
    decorate(object).map(&:options_hash_entry).to_h
  end

  def self.color
    Color
  end

  def color
    self.class.color
  end

  def self.currency
    Currency
  end

  def currency
    self.class.currency
  end

  private_class_method :new
end
