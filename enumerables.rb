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

  # my_select
  def my_select
    return to_enum(:my_select) unless block_given?

    array = []
    my_each do |i|
      array << i if yield(i)
    end
    array
  end

  # ay_all?
  def my_all?(param = nil)
    first_counter = 0
    second_counter = 0
    if block_given?
      my_each { |i| first_counter += 1 if yield(i) }
      first_counter == size
    else
      case param
      when nil
        my_each { |i| return true unless i.nil? || !i }
      when Regexp
        my_each { |i| return true if i =~ param }
      when Class
        my_each { |i| return true if i.is_a? param }
      else
        my_each { |elem| second_counter += 1 if !elem.nil? == true }
        second_counter == size
      end
    end
  end
end

# rubocop: enable all metrics