require 'set'
INPUT = File.readlines('input.txt', chomp: true)
ENERGIZED = Hash.new { |hash, key| hash[key] = Set[] }
INPUT.each { puts _1 }

RIGHT = proc { |y, x| [y, x + 1] }
LEFT = proc { |y, x| [y, x - 1] }
UP = proc { |y, x| [y - 1, x] }
DOWN = proc { |y, x| [y + 1, x] }

def increment_laser(current_position, current_direction)
  energized_count = ENERGIZED[current_position].size
  ENERGIZED[current_position] << current_direction
  return if energized_count == ENERGIZED[current_position].size

  i, j = current_position
  point = INPUT[i][j]

  if point == '-' && [UP, DOWN].include?(current_direction)
    left = LEFT[current_position]
    right = RIGHT[current_position]

    i, j = left
    increment_laser(left, LEFT) if INPUT&.[](i)&.[](j) && i >= 0 && j >= 0

    k, l = right
    increment_laser(right, RIGHT) if INPUT&.[](k)&.[](l) && k >= 0 && l >= 0
    return
  end

  if point == '|' && [RIGHT, LEFT].include?(current_direction)
    up = UP[current_position]
    down = DOWN[current_position]

    i, j = up
    increment_laser(up, UP) if INPUT&.[](i)&.[](j) && i >= 0 && j >= 0

    k, l = down
    increment_laser(down, DOWN) if INPUT&.[](k)&.[](l) && k >= 0 && l >= 0
    return
  end

  new_direction = current_direction
  case
  when current_direction == UP
    new_direction = RIGHT if point == '/'
    new_direction = LEFT if point == '\\'
  when current_direction == DOWN
    new_direction = RIGHT if point == '\\'
    new_direction = LEFT if point == '/'
  when current_direction == LEFT
    new_direction = UP if point == '\\'
    new_direction = DOWN if point == '/'
  when current_direction == RIGHT
    new_direction = UP if point == '/'
    new_direction = DOWN if point == '\\'
  end

  new_position = new_direction[current_position]

  i, j = new_position
  return unless INPUT&.[](i)&.[](j) && i >= 0 && j >= 0

  increment_laser(new_position, new_direction)
end

max = 0
length = INPUT.size
width = INPUT.first.size

(0...length).each do |index|
  increment_laser([index, 0], RIGHT)
  max = [ENERGIZED.size, max].max
  ENERGIZED.clear
  increment_laser([index, width - 1], LEFT)
  max = [ENERGIZED.size, max].max
  ENERGIZED.clear
end

(0...width).each do |index|
  increment_laser([0, index], DOWN)
  max = [ENERGIZED.size, max].max
  ENERGIZED.clear
  increment_laser([length - 1, index], UP)
  max = [ENERGIZED.size, max].max
  ENERGIZED.clear
end

puts max
