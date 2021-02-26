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

  # my_all?
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
      my_each do |i|
        if yield(i)
          counter += 1
        end
      end
      counter
    else
      case param
      when nil
        size
      when Numeric
        my_each { |i| counter +=1 if param == i }
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
  def my_inject(initial = nil, operator = nil)
    raise LocalJumpError unless block_given? || operator || initial || my_all?(String)

    if initial && operator
      result = initial
      my_each { |item| result = result.send(operator, item) }
    elsif initial.is_a?(Symbol) || initial.is_a?(String)
      result = first
      range_arr = to_a
      (1..size - 1).my_each { |item| result = result.send(initial.to_sym, range_arr[item]) }
    elsif my_all?(String)
      longest_word = ''
      my_each { |item| longest_word = item if item.size > longest_word.size }
      return longest_word
    elsif block_given?
      if initial
        result = initial
        my_each { |item| result = yield(result, item) }
      else
        result = first
        range_arr = to_a
        (1..size - 1).my_each { |item| result = yield(result, range_arr[item]) }
      end
    end
    result
  end
end

# 1. my_each
puts 'my_each'
puts '-------'
puts [1, 2, 3].my_each { |elem| print "#{elem + 1} " } # => 2 3 4
p(5..10).my_each { |i| puts i.to_s }
puts

# 2. my_each_with_index
puts 'my_each_with_index'
puts '------------------'
print [1, 2, 3].my_each_with_index { |elem, idx| puts "#{elem} : #{idx}" } # => 1 : 0, 2 : 1, 3 : 2
# p (1..3).my_each_with_index { |elem, idx| puts "
my_each_with_index_output = ''
enum = (1..5)
block = proc { |num, idx| my_each_with_index_output += "Num: #{num}, idx: #{idx}\n" }
p enum.each_with_index(&block)
my_each_with_index_output = ''
p enum.my_each_with_index(&block)
puts

# 3. my_select
puts 'my_select'
puts '---------'
p [1, 2, 3, 8].my_select(&:even?) # => [2, 8]
p [0, 2018, 1994, -7].my_select(&:positive?) # => [2018, 1994]
p [6, 11, 13].my_select(&:odd?) # => [11, 13]
p (1..5).my_select(&:odd?) # => [1, 3, 5]
puts

# 4. my_all? (example test cases)
puts 'my_all?'
puts '-------'
p [3, 5, 7, 11].my_all?(&:odd?) # => true
p [-8, -9, -6].my_all?(&:negative?) # => true
p [3, 5, 8, 11].my_all?(&:odd?) # => false
p [-8, -9, -6, 0].my_all?(&:negative?) # => false
# test cases required by tse reviewer
p [1, 2, 3, 4, 5].my_all? # => true
p [1, 2, 3, false].my_all? # => false
p [1, 2, 3].my_all?(Integer) # => true
p %w[dog door rod blade].my_all?(/d/) # => true
p [1, 1, 1].my_all?(1) # => true
false_block = proc { |n| n < 5 }
p (1..5).my_all?(&false_block) # false
p [1, 2.2, 3, 0.6].my_all? #=> True
puts

# 5. my_any? (example test cases)
puts 'my_any?'
puts '-------'
p [7, 10, 4, 5].my_any?(&:even?) # => true
p %w[q r s i].my_any? { |char| 'aeiou'.include?(char) } # => true
p [7, 11, 3, 5].my_any?(&:even?) # => false
p %w[q r s t].my_any? { |char| 'aeiou'.include?(char) } # => false
# test cases required by tse reviewer
p [3, 5, 4, 11].my_any? # => true
p "yo? #{[nil, false, nil, false].my_any?}" # => false
p [1, nil, false].my_any?(1) # => true
p [1.1, nil, false].my_any?(Numeric) # => true
p %w[dog door rod blade].my_any?(/z/) # => false
p [1, 2, 3].my_any?(1) # => true
p %w[a cat dog].my_any?('cat') #=>true
puts

# 6. my_none? (example test cases)
puts 'my_none?'
puts '--------'
p [3, 5, 7, 11].my_none?(&:even?) # => true
p [1, 2, 3, 4].my_none? { |num| num > 4 } #=> true
p [nil, false, nil, false].my_none? # => true
p %w[sushi pizza burrito].my_none? { |word| word[0] == 'a' } # => true
p [3, 5, 4, 7, 11].my_none?(&:even?) # => false
p %w[asparagus sushi pizza apple burrito].my_none? { |word| word[0] == 'a' } # => false
# test cases required by tse reviewer
p [1, 2, 3].my_none? # => false
p [1, 2, 3].my_none?(String) # => true
p [1, 2, 3, 4, 5].my_none?(2) # => false
p [1, 2, 3].my_none?(4) # => true
p %w[sushi pizza burrito].my_none?(/y/) # => true
puts

# 7. my_count (example test cases)
puts 'my_count'
puts '--------'
p [1, 4, 3, 8].my_count(&:even?) # => 2
p %w[DANIEL JIA KRITI dave].my_count { |s| s == s.upcase } # => 3
p %w[daniel jia kriti dave].my_count { |s| s == s.upcase } # => 0
# test cases required by tse reviewer
p [1, 2, 3].my_count # => 3
p [1, 1, 1, 2, 3].my_count(1) # => 3
p (1..3).my_count #=> 3
puts

# 8. my_map
puts 'my_map'
puts '------'
p [1, 2, 3].my_map { |n| 2 * n } # => [2,4,6]
p %w[Hey Jude].my_map { |word| "#{word}?" } # => ["Hey?", "Jude?"]
p [false, true].my_map(&:!) # => [true, false]
my_proc = proc { |num| num > 10 }
p [18, 22, 5, 6].my_map(my_proc) { |num| num < 10 } # => true true false false
puts

# 9. my_inject
puts 'my_inject'
puts '---------'
p [1, 2, 3, 4].my_inject(10) { |accum, elem| accum + elem } # => 20
p [1, 2, 3, 4].my_inject { |accum, elem| accum + elem } # => 10
p [5, 1, 2].my_inject(:+) # => 8
p [5, 1, 2].my_inject(:*) # => 10
p (5..10).my_inject(2, :*) # should return 302400
p(5..10).my_inject(4) { |prod, n| prod * n } # should return 604800
p (5..10).my_inject

# rubocop: enable all metrics
