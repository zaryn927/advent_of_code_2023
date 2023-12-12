grid = []
start = nil
count = 1

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

current = neighbors.first
puts start.inspect, current.inspect

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
  puts current.inspect
  count += 1
end

puts count / 2
