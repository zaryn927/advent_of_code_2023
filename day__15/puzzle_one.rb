sequence = File.read('input.txt').chomp.split(',')
total = 0
seen = {}

def algo(step)
  value = 0
  step.each_byte do |c|
    value += c
    value *= 17
    value %= 256
  end
  value
end


sequence.each do |step|
  seen[step] ||= algo(step)
  total += seen[step]
end

puts total
