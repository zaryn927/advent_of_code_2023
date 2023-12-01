input = File.readlines('input.txt', chomp: true)
gear_locations = {}

input.each_with_index do |line, index|
  element_index = 0

  line.scan(/\w+|\W/).each do |element|
    element = Integer(element) rescue false

    if element
      length = element.to_s.size
      symbol = /\*/

      if element_index.positive? && line&.[](element_index - 1)&.match?(symbol)
        gear_locations[[element_index - 1, index]] = gear_locations.fetch([element_index - 1, index], []) << element
      end
      if line&.[](element_index + length)&.match?(symbol)
        gear_locations[[element_index + length, index]] = gear_locations.fetch([element_index + length, index], []) << element
      end
      if index.positive? && element_index.positive? && input&.[](index - 1)&.[](element_index - 1)&.match?(symbol)
        gear_locations[[element_index - 1, index - 1]] = gear_locations.fetch([element_index - 1, index - 1], []) << element
      end
      if index.positive? && input&.[](index - 1)&.[](element_index + length)&.match?(symbol)
        gear_locations[[element_index + length, index - 1]] = gear_locations.fetch([element_index + length, index - 1], []) << element
      end
      if element_index.positive? && input&.[](index + 1)&.[](element_index - 1)&.match?(symbol)
        gear_locations[[element_index - 1, index + 1]] = gear_locations.fetch([element_index - 1, index + 1], []) << element
      end
      if input&.[](index + 1)&.[](element_index + length)&.match?(symbol)
        gear_locations[[element_index + length, index + 1]] = gear_locations.fetch([element_index + length, index + 1], []) << element
      end
      index.positive? && input&.[](index - 1)&.[](element_index...element_index + length)&.each_char&.with_index do |e, i|
        gear_locations[[element_index + i, index - 1]] = gear_locations.fetch([element_index + i, index - 1], []) << element if e.match?(symbol)
      end
      input&.[](index + 1)&.[](element_index...element_index + length)&.each_char&.with_index do |e, i|
        gear_locations[[element_index + i, index + 1]] = gear_locations.fetch([element_index + i, index + 1], []) << element if e.match?(symbol)
      end

      element_index += length
    else
      element_index += 1
    end
  end
end

puts gear_locations.select! { |_k, v| v.size == 2 }.values.map { |v| v.inject(:*) }.sum
