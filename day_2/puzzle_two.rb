total = 0

File.foreach('input.txt') do |line|
  colors = {
    red: 0,
    green: 0,
    blue: 0
  }
  line = line.split(/[:,;]/)
  (1...line.size).each do |i|
    element = line[i].strip.split(' ')
    colors[element[1].to_sym] = [element[0].to_i, colors[element[1].to_sym]].max
  end
  total += colors.values.inject(:*)
end

puts total
