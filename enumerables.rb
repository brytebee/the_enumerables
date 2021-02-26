# rubocop: disable all metrics

# frozen_string_literal: true

# Description/Explanation of the Enumerable module
# containly mainly used methods.
module Enumerable
   # my_each
   def my_each
    return to_enum(:my_each) unless block_given?
    i = 0
    while i < to_a.size
      yield(to_a[i])
      i += 1
    end
    self
  end
end

# rubocop: enable all metrics