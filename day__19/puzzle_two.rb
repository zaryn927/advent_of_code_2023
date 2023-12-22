Possibility = Struct.new(:x, :m, :a, :s) # X-MAS parts
Instruction = Struct.new(:field, :comparator, :value, :go_to)

def main
  workflows_info = parse_file
  workflows = {}
  possibilities = []

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

    workflows[name] = proc do |p|
      possibility = Possibility.new(p.x, p.m, p.a, p.s)
      instructions.each do |inst|
        go_to = workflows[inst.go_to]
        unless inst.comparator
          go_to.call(possibility)
          break
        end

        left = possibility.send(inst.field).to_a
        comparator = inst.comparator.to_sym.to_proc
        right = inst.value.to_i
        possibility_for_field = left.filter { |n| comparator.call(n, right) }
        negative_case = left.reject { |n| comparator.call(n, right) }

        next if possibility_for_field.empty?

        possibility.send("#{inst.field}=", (possibility_for_field.first..possibility_for_field.last))
        go_to.call(possibility)
        possibility.send("#{inst.field}=", (negative_case.first..negative_case.last))
      end
    end
  end

  workflows['A'] = proc { |possibility| possibilities << [possibility.x.count, possibility.m.count, possibility.a.count, possibility.s.count].inject(:*) }
  workflows['R'] = proc {}

  workflows['in'][Possibility.new((1..4000), (1..4000), (1..4000), (1..4000))]
  puts possibilities.sum
end

def parse_file
  workflows = []

  File.foreach('input.txt', chomp: true) do |line|
    return workflows if line.empty?

    workflows << line
  end
end

main
