$platform = File.readlines('input.txt', chomp: true)

$platform.each { puts _1 }
puts '----------------------'

def roll_north(i, j)
  col = $platform.map { _1[j] }
  (i - 1).downto(0) do |idx|
    if idx.zero? && col[idx] == '.' # it reached the edge
      $platform[idx][j] = 'O'
      $platform[i][j] = '.'
    end
    next if col[idx] == '.' # it rolled through empty space

    break if (idx + 1) == i # it was already against another rock

    $platform[idx + 1][j] = 'O' # we found the rock it's going to run into; swap and exit
    $platform[i][j] = '.'
    break
  end
end

$platform.each_with_index do |row, i|
  row.each_char.with_index do |c, j|
    next if i.zero?

    roll_north(i, j) if c == 'O'
  end
end

$platform.each { puts _1 }

puts $platform.map.with_index { |row, i| row.count('O') * ($platform.size - i) }.sum
