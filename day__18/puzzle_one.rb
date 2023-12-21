Location = Struct.new(:y, :x)

def main
  input = File.readlines('input.txt', chomp: true).map(&:split)

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

  current_location = Location.new(-min_y, -min_x)
  last_direction = nil
  vertical_colors = {}
  count = 0

  input.each do |entry|
    direction, distance, color = entry
    grid[current_location.y][current_location.x] = get_bend(last_direction, direction) if last_direction

    last_direction = direction

    case direction
    when 'U'
      vertical_colors[color] = 'stub'
      distance.to_i.times { current_location.y -= 1; grid[current_location.y][current_location.x] = '|'; count += 1 }
    when 'D'
      vertical_colors[color] = 'stub'
      distance.to_i.times { current_location.y += 1; grid[current_location.y][current_location.x] = '|'; count += 1 }
    when 'R'
      distance.to_i.times { current_location.x += 1; grid[current_location.y][current_location.x] = '-'; count += 1 }
    when 'L'
      distance.to_i.times { current_location.x -= 1; grid[current_location.y][current_location.x] = '-'; count += 1 }
    end
  end

  grid[current_location.y][current_location.x] = get_bend(last_direction, input.first.first)

  grid.each_with_index do |row, i|
    row.each_with_index do |point, j|
      next unless point == '.'

      ray = row[j + 1...row.size].reject { |p| p == '-' }.join
      intersections = ray.scan(/L7|FJ|\|/).count
      if intersections.odd?
        grid[i][j] = '#'
        count += 1
      end
    end
  end

  grid.each { puts _1.join }
  puts count
end

def get_bend(last_direction, direction)
  case 
  when last_direction == 'R' && direction == 'D', last_direction == 'U' && direction == 'L'
    '7'
  when last_direction == 'D' && direction == 'L', last_direction == 'R' && direction == 'U'
    'J'
  when last_direction == 'L' && direction == 'U', last_direction == 'D' && direction == 'R'
    'L'
  when last_direction == 'U' && direction == 'R', last_direction == 'L' && direction == 'D'
    'F'
  end
end

main
