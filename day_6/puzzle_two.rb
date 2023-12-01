input = File.readlines('input.txt', chomp: true)
time = input.first.split(' ')[1..].inject(:concat).to_i
distance = input.last.split(' ')[1..].inject(:concat).to_i
mid = time / 2
count = 0
greater_than_record = true

while greater_than_record
  if mid * (time - mid) > distance
    count += 1
    mid -= 1
  else
    greater_than_record = false
  end
end

count *= 2
count -= 1 if time.even?

puts count
