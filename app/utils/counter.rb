# frozen_string_literal: true

class Counter
  attr_accessor :collection

  def initialize(collection)
    self.collection = collection
  end

  def counts
    @counts ||=
      collection
        .each_with_object(Hash.new(0)) { |el, cts| cts[el] += 1 }
  end
end
