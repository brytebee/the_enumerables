# frozen_string_literal: true

# Description/Explanation of the Enumerable module
# containly mainly used methods.
# rubocop:disable Metric/ModuleLength
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

  # rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/CyclomaticComplexity
  # my_all?
  def my_all?(param = nil)
    if block_given?
      to_a.my_each { |item| return false if yield(item) == false }
      return true
    elsif param.nil?
      to_a.my_each { |item| return false if item.nil? || item == false }
    elsif !param.nil? && (param.is_a? Class)
      to_a.my_each { |item| return false unless [item.class, item.class.superclass].include?(param) }
    elsif !param.nil? && param.instance_of?(Regexp)
      to_a.my_each { |item| return false unless param.match(item) }
    else
      to_a.my_each { |item| return false if item != param }
    end
    true
  end

  # my_any?
  def my_any?(param = nil)
    if block_given?
      my_each { |i| return true if yield(i) }
      return false
    else
      case param
      when nil
        my_each { |i| return true if i }
      when Class
        my_each { |i| return true if [i.class, i.class.superclass].include?(param) }
      when Regexp
        my_each { |i| return true if param.match(i) }
      else
        my_each { |i| return true if i == param }
      end
    end
    false
  end

  # my_none?
  def my_none?(param = nil)
    initial_value = true
    if block_given?
      my_each do |i|
        initial_value = false if yield(i)
      end
      initial_value
    else
      case param
      when nil
        my_each { |i| return false unless i.nil? || !i }
      when Regexp
        my_each { |i| return false if i =~ param }
      when Class
        my_each { |i| return false if i.is_a? param }
      else
        my_each { |i| return false if i == param }
      end
    end
    initial_value
  end

  # my_count
  def my_count(param = nil)
    counter = 0
    if block_given?
      my_each { |i| counter += 1 if yield(i) }
      counter
    else
      case param
      when nil
        size
      when Numeric
        my_each { |i| counter += 1 if param == i }
        counter
      end
    end
  end

  # my_map
  def my_map(param = nil)
    return to_enum(:my_map) unless block_given?

    array = []
    my_each { |i| array << yield(i) if param.nil? }
    my_each { |i| array << param.call(i) } unless param.nil?
    array
  end

  # my_inject
  def my_inject(initial = nil, sym = nil)
    if (!initial.nil? && sym.nil?) && (initial.is_a?(Symbol) || initial.is_a?(String))
      sym = initial
      initial = nil
    end
    if !block_given? && !sym.nil?
      to_a.my_each { |item| initial = initial.nil? ? item : initial.send(sym, item) }
    else
      to_a.my_each { |item| initial = initial.nil? ? item : yield(initial, item) }
    end
    initial
  end

  # rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/CyclomaticComplexity
  # rubocop:enable Metric/ModuleLength
end

def multiply_els(input)
  input.my_inject(:*)
end
