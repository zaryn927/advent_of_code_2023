input = File.readlines('input.txt', chomp: true)
time = input.first.split(' ')[1..]
distance = input.last.split(' ')[1..]
combined = time.zip(distance).to_h
counts = []

combined.each do |t, d|
  t = t.to_i
  d = d.to_i
  mid = t / 2
  count = 0
  greater_than_record = true
  while greater_than_record
    if mid * (t - mid) > d
      count += 1
      mid -= 1
    else
      greater_than_record = false
    end
  end
  count *= 2
  count -= 1 if t.even?
  counts << count
end

puts counts.inject(:*)
