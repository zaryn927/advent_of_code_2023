Mod = Struct.new(:destinations, :function, :memory)
MODULES = {}
QUEUE = []
$low_pulses = 0
$high_pulses = 0

def main
  parse_file
  bc_mod = MODULES['broadcaster']

  1000.times do
    bc_mod.function[bc_mod.destinations, false]

    until QUEUE.empty?
      origin, mod_name, pulse = QUEUE.shift
      mod = MODULES[mod_name]
      results = mod.function[origin, mod_name, mod.memory, mod.destinations, pulse]
      $high_pulses += results.map(&:last).count { _1 }
      $low_pulses += results.map(&:last).count(&:!)
      results = results.filter { MODULES.keys.include?(_1[1]) }
      results.each { QUEUE << _1 }
    end
  end

  puts $low_pulses * $high_pulses
end

def flip_flop(_, this, memory, destinations, pulse)
  if !pulse
    MODULES[this].memory = !memory
    memory = !memory
    destinations.map { |d| [this, d, memory] }
  else
    []
  end
end

def conjunction(origin, this, memory, destinations, pulse)
  memory[origin] = pulse
  if memory.values.all?
    destinations.map { |d| [this, d, false] }
  else
    destinations.map { |d| [this, d, true] }
  end
end

def broadcaster(destinations, pulse)
  $low_pulses += destinations.size + 1
  destinations.each do |d|
    d_mod = MODULES[d]
    results = d_mod.function['broadcaster', d, d_mod.memory, d_mod.destinations, pulse]
    $high_pulses += results.map(&:last).count { _1 }
    $low_pulses += results.map(&:last).count(&:!)
    results.each { QUEUE << _1 }
  end
end

def parse_file
  conj_mods = []
  File.foreach('input.txt', chomp: true) do |line|
    origin, destinations = line.split(' -> ')
    origin = origin.split('')
    type = origin.shift if ['%', '&'].include?(origin.first)
    mod = origin.join
    conj_mods << mod if type == '&'
    destinations = destinations.split(', ')
    function, memory = if type == '%'
                         [method(:flip_flop), false]
                       elsif type == '&'
                         [method(:conjunction), {}]
                       else
                         [method(:broadcaster), nil]
                       end
    MODULES[mod] = Mod.new(destinations, function, memory)
  end

  MODULES.each do |name, struct|
    overlap = struct.destinations & conj_mods
    overlap.each do |mod|
      MODULES[mod].memory[name] = false
    end
  end
end

main
