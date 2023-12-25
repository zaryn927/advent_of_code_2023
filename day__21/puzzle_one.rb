require 'set'

visited = {}
queue = Hash.new { |hash, key| hash[key] = Set[] }
input = File.readlines('input.txt', chomp: true)
height = input.size
width = input.first.size

input.each_with_index do |line, i|
  j = line.index('S')
  queue[0] << [i, j] if j
end

until queue.empty?
  current_distance = queue.keys.min
  current_locations = queue.delete(current_distance)
  current_locations.each do |location|
    i, j = location
    neigbors = [[i + 1, j], [i - 1, j], [i, j + 1], [i, j - 1]]
    neigbors = neigbors.reject { |n| n[0] >= height || n[0].negative? || n[1] >= width || n[1].negative? || input[n[0]][n[1]] == '#' || visited[n] }
    neigbors.each { |n| queue[current_distance + 1] << n }
    visited[location] = current_distance
  end
end

puts visited.filter { |k, v| v <= 64 && v.even? }.size
