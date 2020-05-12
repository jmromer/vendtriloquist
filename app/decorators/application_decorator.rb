# frozen_string_literal: true

require "utils/localization"

class ApplicationDecorator < SimpleDelegator
  include Localization
  extend Localization

  alias undecorated __getobj__

  def self.decorate(object)
    return new(object) unless object.respond_to?(:map)

    object.map { |obj| new(obj) }
  end

  def self.options(object)
    decorate(object).map(&:options_hash_entry).to_h
  end

  private_class_method :new
end
