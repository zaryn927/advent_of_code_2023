galaxy_map = []
galaxy_coordinates = {}
expanded_rows = []
expanded_cols = []
total = 0

File.foreach('input.txt', chomp: true).with_index do |line, i|
  line = line.split('')
  galaxy_map << line
  expanded_rows << i if line.all? { _1 == '.' }
end

(0...galaxy_map.first.size).each do |i|
  col = galaxy_map.map { |r| r[i] }
  expanded_cols << i if col.all? { _1 == '.' }
end

galaxy_map.each_with_index { |r, i| r.each_with_index { |e, j| galaxy_coordinates[galaxy_coordinates.size + 1] = [i, j] if e == '#' } }

galaxy_coordinates.each do |k, v|
  break if k == galaxy_coordinates.size

  (k + 1..galaxy_coordinates.size).each do |n|
    y1 = v[0]
    y2 = galaxy_coordinates[n][0]
    x1 = v[1]
    x2 = galaxy_coordinates[n][1]

    included_rows = expanded_rows.count { |y| ([y1, y2].min..[y1, y2].max).include?(y) }
    included_cols = expanded_cols.count { |x| ([x1, x2].min..[x1, x2].max).include?(x) }

    total += (((y1 - y2).abs + (included_rows * 999_999)) + ((x1 - x2).abs + (included_cols * 999_999)))
  end
end

puts total
