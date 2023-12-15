$platform = File.readlines('input.txt', chomp: true)
$seen = [Marshal.load(Marshal.dump($platform))]

def roll_north(i, j)
  col = $platform.map { _1[j] }
  (i - 1).downto(0) do |idx|
    if idx.zero? && col[idx] == '.' # it reached the edge
      $platform[idx][j] = 'O'
      $platform[i][j] = '.'
      break
    end
    next if col[idx] == '.' # it rolled through empty space

    break if (idx + 1) == i # it was already against another rock

    $platform[idx + 1][j] = 'O' # we found the rock it's going to run into; swap and exit
    $platform[i][j] = '.'
    break
  end
end

def roll_south(i, j)
  col = $platform.reverse.map { _1[j] }
  (i - 1).downto(0) do |idx|
    if idx.zero? && col[idx] == '.' # it reached the edge
      $platform.reverse[idx][j] = 'O'
      $platform.reverse[i][j] = '.'
      break
    end
    next if col[idx] == '.' # it rolled through empty space

    break if (idx + 1) == i # it was already against another rock

    $platform.reverse[idx + 1][j] = 'O' # we found the rock it's going to run into; swap and exit
    $platform.reverse[i][j] = '.'
    break
  end
end

def roll_west(i, j)
  row = $platform[i]
  (j - 1).downto(0) do |idx|
    if idx.zero? && row[idx] == '.' # it reached the edge
      $platform[i][idx] = 'O'
      $platform[i][j] = '.'
      break
    end
    next if row[idx] == '.' # it rolled through empty space

    break if (idx + 1) == j # it was already against another rock

    $platform[i][idx + 1] = 'O' # we found the rock it's going to run into; swap and exit
    $platform[i][j] = '.'
    break
  end
end

def roll_east(i, j)
  row = $platform[i].reverse
  last = $platform[i].size - 1
  (j - 1).downto(0) do |idx|
    if idx.zero? && row[idx] == '.' # it reached the edge
      $platform[i][last - idx] = 'O'
      $platform[i][last - j] = '.'
      break
    end
    next if row[idx] == '.' # it rolled through empty space

    break if (idx + 1) == j # it was already against another rock

    $platform[i][last - (idx + 1)] = 'O' # we found the rock it's going to run into; swap and exit
    $platform[i][last - j] = '.'
    break
  end
end

def spin(times)
  times.times do
    $platform.each_with_index do |row, i|
      row.each_char.with_index do |c, j|
        next if i.zero?

        roll_north(i, j) if c == 'O'
      end
    end
    $platform.each_with_index do |row, i|
      row.each_char.with_index do |c, j|
        next if j.zero?

        roll_west(i, j) if c == 'O'
      end
    end
    $platform.reverse.each_with_index do |row, i|
      row.each_char.with_index do |c, j|
        next if i.zero?

        roll_south(i, j) if c == 'O'
      end
    end
    $platform.each_with_index do |row, i|
      row.reverse.each_char.with_index do |c, j|
        next if j.zero?

        roll_east(i, j) if c == 'O'
      end
    end
    copy = Marshal.load(Marshal.dump($platform))
    return [$seen.index(copy), $seen.size - $seen.index(copy)] if $seen.include?(copy)

    $seen << copy
  end
end

n = 1_000_000_000
offset, range = spin(n)

puts $seen[((n - offset) % range) + offset].map.with_index { |row, i| row.count('O') * ($platform.size - i) }.sum
