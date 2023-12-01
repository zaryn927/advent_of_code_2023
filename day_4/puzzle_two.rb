input = File.readlines('input.txt', chomp: true)
counts = Hash.new(0)

input.each do |line|
  (card, winners, numbers) = line.split(/[:|]/)
  current_game = card.split(' ').last.to_i
  counts[current_game] += 1
  matches = (winners.strip.split(' ') & numbers.strip.split(' ')).length
  (current_game + 1..current_game + matches).each do |game|
    counts[game] += counts[current_game]
  end
end

puts counts.values.sum
