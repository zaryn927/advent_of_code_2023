total = 0

File.foreach('input.txt') do |line|
  line = line.split(/[:|]/)
  matches = (line[1].strip.split(' ') & line[2].strip.split(' ')).length
  total += 2**(matches - 1) if matches.positive?
end

puts total
