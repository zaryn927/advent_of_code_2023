Mod = Struct.new(:destinations, :function, :memory)

def main
  mods = parse_file
  low_pulses = 0
  high_pulses = 0
  puts mods
end

def parse_file(mods = {})
  flip_flop = proc { |input_pulse, mod| }
  conjunction = proc { |mod| }
  broadcast = proc {}

  conj_mods = []
  File.foreach('sample.txt', chomp: true) do |line|
    origin, destinations = line.split(' -> ')
    origin = origin.split('')
    type = origin.shift if ['%', '&'].include?(origin.first)
    mod = origin.join
    conj_mods << mod if type == '&'
    destinations = destinations.split(', ')
    function, memory = if type == '%'
                         [flip_flop, false]
                       elsif type == '&'
                         [conjunction, []]
                       else
                         [broadcast, nil]
                       end
    mods[mod] = Mod.new(destinations, function, memory)
  end

  mods.each do |name, struct|
    if struct.destinations
  end
  mods
end

main
