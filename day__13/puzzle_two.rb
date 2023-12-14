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

def check_inside(match, grid, col = false)
  lower = match[0] + 1
  upper = match[1] - 1
  get_line = col ? proc { |idx| grid.map { _1[idx] } } : proc { |idx| grid[idx] }

  while upper > lower
    break unless get_line[upper] == get_line[lower]

    upper -= 1
    lower += 1
  end

  [lower > upper, lower]
end

def check_outside(match, grid, col = false)
  lower = match[0] - 1
  upper = match[1] + 1
  size = col ? grid.first.size : grid.size
  get_line = col ? proc { |idx| grid.map { _1[idx] } } : proc { |idx| grid[idx] }

  while lower >= 0 && upper < size
    break unless get_line[upper] == get_line[lower]

    upper += 1
    lower -= 1
  end

  lower.negative? || upper == size
end

def find_one_away_matches(grid, col = false)
  outer_size = col ? grid.first.size : grid.size
  inner_size = col ? grid.size : grid.first.size
  get_line = col ? proc { |idx| grid.map { _1[idx] } } : proc { |idx| grid[idx] }
  matches = []

  (0...outer_size).each do |i|
    (i + 1...outer_size).each do |j|
      line1 = get_line[i]
      line2 = get_line[j]
      diff_count = 0
      (0...inner_size).each do |k|
        diff_count += 1 unless line1[k] == line2[k]
      end
      matches << [i, j] if diff_count == 1 && (j - i).odd?
    end
  end

  matches
end

grids.each do |g|
  row_matches = find_one_away_matches(g)
  col_matches = find_one_away_matches(g, true)

  row_matches.each do |match|
    check1, value = check_inside(match, g)
    check2 = check_outside(match, g)
    temp = value * 100 if check1 && check2
    count += temp if temp
  end

  col_matches.each do |match|
    check1, value = check_inside(match, g, true)
    check2 = check_outside(match, g, true)
    temp = value if check1 && check2
    count += temp if temp
  end
end

puts count
