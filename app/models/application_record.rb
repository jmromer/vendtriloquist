# frozen_string_literal: true

require "utils/currency"

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def decorated
    "#{self.class}Decorator".constantize.decorate(self)
  end
end
