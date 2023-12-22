Part = Struct.new(:x, :m, :a, :s) # X-MAS parts
Instruction = Struct.new(:field, :comparator, :value, :go_to)

def main
  workflows_info, parts_info = parse_file
  workflows = {}
  parts = []
  total = 0

  workflows_info.each do |workflow|
    name, instructions = workflow.split(/[{}]/)
    instructions = instructions.split(',')
    instructions = instructions.map do |inst|
      condition, go_to = inst.split(':') if inst.include?(':')
      go_to = inst unless inst.include?(':')
      if condition
        f, c, v = condition.scan(/[><]|(?<=[><])\w+|\w+(?=[><])/)
        Instruction.new(f, c, v, go_to)
      else
        Instruction.new(nil, nil, nil, go_to)
      end
    end

    workflows[name] = proc do |part|
      instructions.each do |inst|
        go_to = workflows[inst.go_to]
        unless inst.comparator
          go_to.call(part)
          break
        end

        left = part.send(inst.field)
        comparator = inst.comparator.to_sym.to_proc
        right = inst.value.to_i

        if comparator.call(left, right)
          go_to.call(part)
          break
        end
      end
    end
  end

  workflows['A'] = proc { |part| total += [part.x, part.m, part.a, part.s].sum }
  workflows['R'] = proc {}

  parts_info.each do |part|
    p = part.split(/[{,}]/).reject(&:empty?).map { _1[2..].to_i }
    parts << Part.new(*p)
  end

  parts.each do |part|
    workflows['in'][part]
  end

  puts total
end

def parse_file
  workflows = []
  parts = []
  part_section = false

  File.foreach('input.txt', chomp: true) do |line|
    if line.empty?
      part_section = true
      next
    end

    if part_section
      parts << line
    else
      workflows << line
    end
  end

  [workflows, parts]
end

main
