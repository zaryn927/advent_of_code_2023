directions = []
nodes = {}

input = File.readlines('input.txt', chomp: true)

input[0].chars.each { |c| directions << (c == 'L' ? 0 : 1) }

current = []

input[2..].each do |line|
  (key, left, right) = line.split(/[\s=(),]/).reject(&:empty?)
  nodes[key] = [left, right]
  current << [key, 0] if key.chars.last == 'A'
end

finished = []
until current.empty?
  current.each do |point|
    directions.each do |d|
      point[0] = nodes[point[0]][d]
      point[1] += 1
      if point[0].chars.last == 'Z'
        finished << current.delete(point)
        break
      end
    end
  end
end

puts finished.map { _1[1] }.reduce(&:lcm)
