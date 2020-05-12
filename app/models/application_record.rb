# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # decorates the receiver using a conventionally named decorator class.
  def decorated
    "#{self.class}Decorator".constantize.decorate(self)
  end
end
