input = File.readlines('sample.txt', chomp: true).map(&:split)

max_y = 0
min_y = 0
max_x = 0
min_x = 0
current_x = 0
current_y = 0

input.each do |entry|
  direction, distance, color = entry

  case direction
  when 'U'
    current_y -= distance.to_i
    max_y = [current_y, max_y].max
    min_y = [current_y, min_y].min
  when 'D'
    current_y += distance.to_i
    max_y = [current_y, max_y].max
    min_y = [current_y, min_y].min
  when 'R'
    current_x += distance.to_i
    max_x = [current_x, max_x].max
    min_x = [current_x, min_x].min
  when 'L'
    current_x -= distance.to_i
    max_x = [current_x, max_x].max
    min_x = [current_x, min_x].min
  end
end

height = max_y - min_y + 1
width = max_x - min_x + 1

grid = Array.new(height) { Array.new(width, '.') }

Location = Struct.new(:y, :x)
current_location = Location.new(-min_y, -min_x)
vertical_colors = {}

input.each do |entry|
  direction, distance, color = entry
  case direction
  when 'U'
    vertical_colors[color] = 'stub'
    distance.to_i.times { current_location.y -= 1; grid[current_location.y][current_location.x] = color }
  when 'D'
    vertical_colors[color] = 'stub'
    distance.to_i.times { current_location.y += 1; grid[current_location.y][current_location.x] = color }
  when 'R'
    distance.to_i.times { current_location.x += 1; grid[current_location.y][current_location.x] = color }
  when 'L'
    distance.to_i.times { current_location.x -= 1; grid[current_location.y][current_location.x] = color }
  end
end

puts vertical_colors
grid.each_with_index do |row, i|
  row.each_with_index do |point, j|
    next unless point == '.'

    count = 0
    (j + 1...row.size).each { |idx| count += 1 if vertical_colors[row[idx]] }
    grid[i][j] = '#' if count.odd?
  end
end

grid.each { puts _1.join }
