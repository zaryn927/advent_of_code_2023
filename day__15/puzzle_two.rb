sequence = File.read('input.txt').chomp.split(',')
boxes = Array.new(256) { {} }
labels = {}
total = 0

def algo(step)
  value = 0
  step.each_byte do |c|
    value += c
    value *= 17
    value %= 256
  end
  value
end


sequence.each do |step|
  label, focal_length = if step.include?('=')
                          step.split('=')
                        else
                          step.split('-')
                        end

  labels[label] ||= algo(label)
  if step.include?('=')
    boxes[labels[label]][label] = focal_length.to_i
  else
    boxes[labels[label]].delete(label)
  end
end

boxes.each_with_index do |box, i|
  box.each_value.with_index do |v, j|
    total += ((i + 1) * (j + 1) * v)
  end
end

puts total
