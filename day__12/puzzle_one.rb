def count_arrangements(row, counts)
  n = row.size
  m = counts.size
  dp = Array.new(n + 1) { Array.new(m + 1, 0) }
  dp[n][m] = 1

  (n - 1).downto(0) do |i|
    (m - 1).downto(0) do |j|
      working = true
      broken = true

      case row[i]
      when '#'
        working = false
      when '.'
        broken = false
      end

      sum = 0
      if broken && counts[j]
        sum += dp[i + 1][j + 1]
      elsif working && !counts[j]
        sum += dp[i + 1][j + 1] + dp[i + 1][j]
      end
      dp[i][j] = sum
    end
  end

  #dp.each_with_index { |e, i| print "#{row[i]}|"; puts e.inspect }
  #puts counts.map { _1 ? 'T' : 'F' }.inspect
  dp[0][0]
end

count = 0

File.foreach('input.txt', chomp: true) do |line|
  row, counts = line.split
  counts = counts.split(',').map { temp = []; _1.to_i.times { temp << true }; temp << false }.flatten
  counts.prepend(false)
  row = ".#{row}."
  #puts row, counts.inspect
  count += count_arrangements(row, counts)
end

puts count
