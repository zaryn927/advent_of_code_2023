Mod = Struct.new(:destinations, :function, :memory)
MODULES = {}
QUEUE = []

def main
  parse_file
  lv_inputs = MODULES.filter { |_, v| v.destinations.include?('lv') }.transform_values { |_| -1 }
  bc_mod = MODULES['broadcaster']
  button_presses = 0

  loop do
    button_presses += 1
    bc_mod.function[bc_mod.destinations, false]

    until QUEUE.empty?
      origin, mod_name, pulse = QUEUE.shift
      mod = MODULES[mod_name]
      next unless mod

      results = mod.function[origin, mod_name, mod.memory, mod.destinations, pulse]
      lv_inputs[mod_name] = button_presses if lv_inputs[mod_name]&.negative? && results.filter { |r| r[1] == 'lv' }.map(&:last).first
      results.each { QUEUE << _1 }
    end

    break if lv_inputs.values.all?(&:positive?)
  end

  puts lv_inputs.values.inject(&:lcm)
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
  destinations.each do |d|
    d_mod = MODULES[d]
    results = d_mod.function['broadcaster', d, d_mod.memory, d_mod.destinations, pulse]
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
