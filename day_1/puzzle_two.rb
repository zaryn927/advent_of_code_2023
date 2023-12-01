total = 0
word_to_num_map = {
  'one'=> 1,
  'two'=> 2,
  'three'=> 3,
  'four'=> 4,
  'five'=> 5,
  'six'=> 6,
  'seven'=> 7,
  'eight'=> 8,
  'nine'=> 9
}
valid_numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

File.foreach('input.txt') do |line|
  earliest = [line.size, nil]
  latest = [-1, nil]
  valid_numbers.each do |value|
    first_occurrence = line.index(value)
    last_occurrence = line.rindex(value)
    earliest = [first_occurrence, value] if first_occurrence&.< earliest[0]
    latest = [last_occurrence, value] if last_occurrence&.> latest[0]
  end
  earliest[1] = word_to_num_map[earliest[1]] || earliest[1]
  latest[1] = word_to_num_map[latest[1]] || latest[1]
  calibration_value = "#{earliest[1]}#{latest[1]}".to_i
  total += calibration_value
end

puts total
