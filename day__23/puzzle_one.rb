$longest = 0
$input = File.readlines('input.txt', chomp: true)
$finish = [$input.size - 1, $input.last.size - 2]

def main
  start = [0, 1]
  step(start, [])
  puts $longest
end

def step(current_position, seen)
  seen << current_position unless current_position == [0, 1]
  if current_position == $finish
    $longest = [seen.size, $longest].max
    return
  end

  y, x = current_position
  right = [y, x + 1] unless x == $input.first.size - 1 || ['#', '<', '^', 'v'].include?($input[y][x + 1])
  left = [y, x - 1] unless x.zero? || ['#', '>', '^', 'v'].include?($input[y][x - 1])
  down = [y + 1, x] unless y == $input.size - 1 || ['#', '<', '^', '>'].include?($input[y + 1][x])
  up = [y - 1, x] unless y.zero? || ['#', '<', '>', 'v'].include?($input[y - 1][x])

  [right, left, down, up].reject { |position| position.nil? || seen.include?(position) }.each do |neighbor|
    step(neighbor, Marshal.load(Marshal.dump(seen)))
  end
end
main
