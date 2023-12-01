total = 0
File.foreach('input.txt') do |line|
  numbers = line.gsub(/[^0-9]/, '').chars
  calibration_value = "#{numbers.first}#{numbers.last}".to_i
  total += calibration_value
end
puts total
