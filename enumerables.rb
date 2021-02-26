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

  # my_each_with_index
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    index = 0
    my_each do |item|
      yield(item, index)
      index += 1
  end
  end
end

# rubocop: enable all metrics