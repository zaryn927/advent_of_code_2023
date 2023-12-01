total = 0
colors = {
  red: 12,
  green: 13,
  blue: 14
}

File.foreach('input.txt') do |line|
  possible = true
  line = line.split(/[:,;]/)
  (1...line.size).each do |i|
    element = line[i].strip.split(' ')
    possible = false if element[0].to_i > colors[element[1].to_sym]
  end
  total += line[0].strip.split(' ')[1].to_i if possible
end

puts total
