Location = Struct.new(:y, :x)

def main
  input = File.readlines('input.txt', chomp: true).map(&:split)

  current_x = 0
  current_y = 0
  area = 0
  border_points = 0

  input.each do |entry|
    color = entry[2]
    color.delete!('(')
    color.delete!(')')
    color = color.split('')
    direction = get_direction(color.pop.to_i)
    distance = color.join.sub(/#/, '0x').hex

    start_x = current_x
    start_y = current_y

    border_points += distance

    case direction
    when 'U'
      current_y -= distance.to_i
    when 'D'
      current_y += distance.to_i
    when 'R'
      current_x += distance.to_i
    when 'L'
      current_x -= distance.to_i
    end

    area_increment = ((current_x + start_x) * (current_y - start_y)) / 2
    area += area_increment
  end

  interior_points = area + 1 - (border_points / 2)

  puts border_points + interior_points
end

def get_direction(n)
  case n
  when 0
    'R'
  when 1
    'D'
  when 2
    'L'
  when 3
    'U'
  end
end

main
