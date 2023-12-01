ranks = {
  five: [],
  four: [],
  full: [],
  three: [],
  two_p: [],
  one_p: [],
  high: []
}

card_strength = {
  '2' => 2,
  '3' => 3,
  '4' => 4,
  '5' => 5,
  '6' => 6,
  '7' => 7,
  '8' => 8,
  '9' => 9,
  'T' => 10,
  'J' => 11,
  'Q' => 12,
  'K' => 13,
  'A' => 14
}

File.foreach('input.txt', chomp: true) do |line|
  hand = line.split(' ').first.chars
  bet = line.split(' ').last.to_i
  case hand.uniq.size
  when 1
    ranks[:five] << [hand, bet]
  when 2
    if hand.count(hand.max_by { |e| hand.count(e) }) == 4
      ranks[:four] << [hand, bet]
    else
      ranks[:full] << [hand, bet]
    end
  when 3
    if hand.count(hand.max_by { |e| hand.count(e) }) == 3
      ranks[:three] << [hand, bet]
    else
      ranks[:two_p] << [hand, bet]
    end
  when 4
    ranks[:one_p] << [hand, bet]
  when 5
    ranks[:high] << [hand, bet]
  end
end

ranks.each_value { |rank| rank.sort_by! { |e| e.first.map { |card| card_strength[card] } }.reverse! }
puts ranks.values.flatten(1).map(&:last).reverse.map.with_index { |e, i| (i + 1) * e }.sum
