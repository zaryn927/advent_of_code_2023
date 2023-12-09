total = 0

def diff(arr)
  diff_arr = arr[1..].map.with_index { |e, i| e - arr[i] }
  if diff_arr.all?(&:zero?)
    arr += [arr.last]
  else
    diff_last = diff(diff_arr).last
    arr += [(arr.last + diff_last)]
  end
end

File.foreach('input.txt', chomp: true) do |line|
  line = line.split(' ').map(&:to_i)
  total += diff(line).last
end

puts total
