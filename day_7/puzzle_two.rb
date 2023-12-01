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
  'J' => 1,
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
    if hand.include?('J')
      ranks[:five] << [hand, bet]
      next
    end
    if hand.count(hand.max_by { |e| hand.count(e) }) == 4
      ranks[:four] << [hand, bet]
    else
      ranks[:full] << [hand, bet]
    end
  when 3
    if hand.count(hand.max_by { |e| hand.count(e) }) == 3
      if hand.include?('J')
        ranks[:four] << [hand, bet]
      else
        ranks[:three] << [hand, bet]
      end
    else
      if hand.count('J') == 2
        ranks[:four] << [hand, bet]
      elsif hand.count('J') == 1
        ranks[:full] << [hand, bet]
      else
        ranks[:two_p] << [hand, bet]
      end
    end
  when 4
    if hand.include?('J')
      ranks[:three] << [hand, bet]
    else
      ranks[:one_p] << [hand, bet]
    end
  when 5
    if hand.include?('J')
      ranks[:one_p] << [hand, bet]
    else
      ranks[:high] << [hand, bet]
    end
  end
end

ranks.each_value { |rank| rank.sort_by! { |e| e.first.map { |card| card_strength[card] } }.reverse! }
puts ranks.values.flatten(1).map(&:last).reverse.map.with_index { |e, i| (i + 1) * e }.sum
