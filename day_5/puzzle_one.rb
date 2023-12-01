seeds = []
seed_to_soil = {}
soil_to_fertilizer = {}
fertilizer_to_water = {}
water_to_light = {}
light_to_temp = {}
temp_to_humidity = {}
humidity_to_location = {}
locations = []

index = 0
File.foreach('input.txt', chomp: true) do |line|
  if line.empty?
    index += 1
    next
  end

  next if line.match(/:$/)

  if index.zero?
    seeds = line.split(' ').map(&:to_i)
    seeds.shift
    next
  end

  (destination, source, length) = line.split(' ').map(&:to_i)

  case index
  when 1
    seed_to_soil[(source...source + length)] = destination - source
  when 2
    soil_to_fertilizer[(source...source + length)] = destination - source
  when 3
    fertilizer_to_water[(source...source + length)] = destination - source
  when 4
    water_to_light[(source...source + length)] = destination - source
  when 5
    light_to_temp[(source...source + length)] = destination - source
  when 6
    temp_to_humidity[(source...source + length)] = destination - source
  when 7
    humidity_to_location[(source...source + length)] = destination - source
  end
end

def transform(element, map)
  value = map.find { |k, _v| k.include?(element) }&.last
  (value&.+ element) || element
end

seeds.each do |s|
  s = transform(s, seed_to_soil)
  s = transform(s, soil_to_fertilizer)
  s = transform(s, fertilizer_to_water)
  s = transform(s, water_to_light)
  s = transform(s, light_to_temp)
  s = transform(s, temp_to_humidity)
  locations << transform(s, humidity_to_location)
end

puts locations.min
