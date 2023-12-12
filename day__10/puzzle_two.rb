grid = []
start = nil

File.foreach('input.txt', chomp: true).with_index do |line, i|
  line = line.split('')
  grid << line
  start = [i, line.index('S')] if line.include?('S')
end

left = proc { |current| [current[0], current[1] - 1, grid&.[](current[0])&.[](current[1] - 1), 'left'] }
right = proc { |current| [current[0], current[1] + 1, grid&.[](current[0])&.[](current[1] + 1), 'right'] }
up = proc { |current| [current[0] - 1, current[1], grid&.[](current[0] - 1)&.[](current[1]), 'up'] }
down = proc { |current| [current[0] + 1, current[1], grid&.[](current[0] + 1)&.[](current[1]), 'down'] }

first_left = left[start]
first_left = nil unless ['-', 'L', 'F'].include?(first_left[2])
first_right = right[start]
first_right = nil unless ['-', '7', 'J'].include?(first_right[2])
first_up = up[start]
first_up = nil unless ['|', '7', 'F'].include?(first_up[2])
first_down = down[start]
first_down = nil unless ['|', 'L', 'J'].include?(first_down[2])
neighbors = [first_left, first_right, first_up, first_down].reject(&:nil?)

neighbor_directions = neighbors.map(&:last)
grid[start[0]][start[1]] = case
                           when neighbor_directions.intersection(%w[left right]).size == 2
                             '-'
                           when neighbor_directions.intersection(%w[left up]).size == 2
                             'J'
                           when neighbor_directions.intersection(%w[left down]).size == 2
                             '7'
                           when neighbor_directions.intersection(%w[right up]).size == 2
                             'L'
                           when neighbor_directions.intersection(%w[right down]).size == 2
                             'F'
                           when neighbor_directions.intersection(%w[up down]).size == 2
                             '|'
                           end

current = neighbors.first
boundaries = [current]

until current[0..1] == start
  current = case current[3]
            when 'left'
              case current[2]
              when '-'
                left[current]
              when 'L'
                up[current]
              when 'F'
                down[current]
              end
            when 'right'
              case current[2]
              when '-'
                right[current]
              when '7'
                down[current]
              when 'J'
                up[current]
              end
            when 'up'
              case current[2]
              when '|'
                up[current]
              when '7'
                left[current]
              when 'F'
                right[current]
              end
            when 'down'
              case current[2]
              when '|'
                down[current]
              when 'L'
                right[current]
              when 'J'
                left[current]
              end
            end
  boundaries << current
end

boundary_locations = boundaries.map { |b| b[0..1] }
ys, xs = boundary_locations.inject(:zip).flatten(0).map(&:flatten)
min_y, max_y = ys.minmax
min_x, max_x = xs.minmax
count = 0
(min_y..max_y).each do |row|
  (min_x..max_x).each do |col|
    next if boundary_locations.include?([row, col])

    ray = boundaries.reject { |b| b[0] != row || b[2] == '-' || b[1] <= col || b[1] > max_x }.sort_by { |b| b[1] }.map { |b| b[2] }.join
    intersections = ray.scan(/L7|FJ|\|/).count
    count += 1 if intersections.odd?
  end
end

puts count
