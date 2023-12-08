directions = []
nodes = {}

input = File.readlines('input.txt', chomp: true)

input[0].chars.each { |c| directions << (c == 'L' ? 0 : 1) }

input[2..].each do |line|
  (key, left, right) = line.split(/[\s=(),]/).reject(&:empty?)
  nodes[key] = [left, right]
end

current = 'AAA'
steps = 0
found = false

until found
  directions.each do |d|
    current = nodes[current][d]
    steps += 1
    if current == 'ZZZ'
      found = true
      break
    end
  end
end

puts steps
