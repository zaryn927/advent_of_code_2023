galaxy_map = []
galaxy_coordinates = {}
total = 0

File.foreach('input.txt', chomp: true) do |line|
  line = line.split('')
  galaxy_map << line
  galaxy_map << Marshal.load(Marshal.dump(line)) if line.all? { _1 == '.' }
end

col_indexes = []
(0...galaxy_map.first.size).each do |i|
  col = galaxy_map.map { |r| r[i] }
  col_indexes << i if col.all? { _1 == '.' }
end

galaxy_map.each { |r| col_indexes.each_with_index { |col, i| r.insert(col + i, '.') } }

galaxy_map.each_with_index { |r, i| r.each_with_index { |e, j| galaxy_coordinates[galaxy_coordinates.size + 1] = [i, j] if e == '#' } }

galaxy_coordinates.each do |k, v|
  break if k == galaxy_coordinates.size

  (k + 1..galaxy_coordinates.size).each { |n| total += ((v[0] - galaxy_coordinates[n][0]).abs + (v[1] - galaxy_coordinates[n][1]).abs) }
end

puts total
