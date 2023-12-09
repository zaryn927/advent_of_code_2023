total = 0

def diff(arr)
  diff_arr = arr[1..].map.with_index { |e, i| e - arr[i] }
  if diff_arr.all?(&:zero?)
    arr.unshift(arr.first)
  else
    diff_first = diff(diff_arr).first
    arr.unshift(arr.first - diff_first)
  end
end

File.foreach('input.txt', chomp: true) do |line|
  line = line.split(' ').map(&:to_i)
  total += diff(line).first
end

puts total
