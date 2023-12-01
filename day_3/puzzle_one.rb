total = 0
input = File.readlines('input.txt', chomp: true)

input.each_with_index do |line, index|
  element_index = 0

  line.scan(/\w+|\W/).each do |element|
    element = Integer(element) rescue false

    if element
      length = element.to_s.size
      symbol = /[^0-9.]/

      left = element_index.positive? && line&.[](element_index - 1)&.match?(symbol)
      right = line&.[](element_index + length)&.match?(symbol)
      up_left = index.positive? && element_index.positive? && input&.[](index - 1)&.[](element_index - 1)&.match?(symbol)
      up_right = index.positive? && input&.[](index - 1)&.[](element_index + length)&.match?(symbol)
      down_left = element_index.positive? && input&.[](index + 1)&.[](element_index - 1)&.match?(symbol)
      down_right = input&.[](index + 1)&.[](element_index + length)&.match?(symbol)
      up = index.positive? && input&.[](index - 1)&.[](element_index...element_index + length)&.match?(symbol)
      down = input&.[](index + 1)&.[](element_index...element_index + length)&.match?(symbol)

      total += element if left || right || up_left || up_right || down_left || down_right || up || down

      element_index += length
    else
      element_index += 1
    end
  end
end

puts total
