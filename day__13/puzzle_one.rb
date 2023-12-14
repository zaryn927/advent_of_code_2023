grids = []
grid = []
count = 0

File.foreach('input.txt', chomp: true) do |line|
  if line.empty?
    grids << grid
    grid = []
  else
    grid << line
  end
end
grids << grid

grids.each do |g|
  row_matches = []
  (1...g.size).each do |i|
    row_matches << [i - 1, i] if g[i] == g[i - 1]
  end

  row_matches.each do |match|
    lower = match[0]
    upper = match[1]

    while lower >= 0 && upper < g.size
      break unless g[upper] == g[lower]

      upper += 1
      lower -= 1
    end

    count += match[1] * 100 if lower.negative? || upper == g.size
  end

  col_matches = []
  (1...g.first.size).each do |i|
    col1 = g.map { |line| line[i - 1] }
    col2 = g.map { |line| line[i] }
    col_matches << [i - 1, i] if col1 == col2
  end

  col_matches.each do |match|
    lower = match[0]
    upper = match[1]

    while lower >= 0 && upper < g.first.size
      break unless g.map { _1[upper] } == g.map { _1[lower] }

      upper += 1
      lower -= 1
    end

    count += match[1] if lower.negative? || upper == g.first.size
  end
end

puts count
